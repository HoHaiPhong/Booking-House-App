const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = new Server(server); // Khởi tạo Chat Realtime

app.use(express.json());
const cors = require('cors');
app.use(cors({
    origin: '*', // Allow all origins for dev
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

// Request Logger
app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
});

// Kết nối các route
const apiRoutes = require('./routes/api');
app.use('/api', apiRoutes);

// Xử lý Chat Realtime [cite: 16, 22]
const { Message } = require('./app/Models'); // Import Model to save to DB

io.on('connection', (socket) => {
    console.log(`User Connected: ${socket.id}`);

    socket.on('join_room', (userId) => {
        socket.join(userId); // Mỗi user join vào room là ID của họ
        console.log(`User with ID: ${userId} joined room: ${userId}`);
    });

    socket.on('send_message', async (data) => {
        // data: { senderId, receiverId, content }
        console.log("Message Data:", data);

        try {
            // Lưu vào DB
            await Message.create({
                gui_tu_id: data.senderId,
                gui_den_id: data.receiverId,
                noi_dung: data.content,
                trang_thai: 'sent'
            });

            // Gửi cho người nhận (emit to receiver's room)
            socket.to(data.receiverId).emit('receive_message', data);

            // Gửi lại cho người gửi (để update UI phía sender nếu cần, hoặc sender tự update)
            socket.emit('receive_message', data);

        } catch (err) {
            console.error("Lỗi lưu tin nhắn:", err);
        }
    });

    socket.on('disconnect', () => {
        console.log("User Disconnected", socket.id);
    });
});


const PORT = process.env.PORT || 5000;
server.listen(PORT, '0.0.0.0', () => console.log(`Server chạy tại cổng ${PORT}`));