const express = require('express');
const router = express.Router();
const PropertyController = require('../app/Controllers/PropertyController');
const AuthController = require('../app/Controllers/AuthController');
const CategoryController = require('../app/Controllers/CategoryController');
const BookingController = require('../app/Controllers/BookingController');
const ReviewController = require('../app/Controllers/ReviewController');
const ChatController = require('../app/Controllers/ChatController');

const authMiddleware = require('../app/Middleware/authMiddleware');

// --- AUTH ---
router.post('/auth/register', AuthController.register);
router.post('/auth/login', AuthController.login);

// --- PROPERTY ---
router.get('/properties', PropertyController.getAllProperties); // Public
router.get('/properties/search', PropertyController.searchByRadius); // Public
router.get('/properties/me', authMiddleware.verifyToken, PropertyController.getMyProperties); // My Properties
router.get('/properties/:id', PropertyController.getPropertyDetail); // Public

// Protected Property Routes (Admin & Host)
router.post('/properties', authMiddleware.verifyToken, authMiddleware.isUserOrAdmin, PropertyController.createProperty);
router.put('/properties/:id', authMiddleware.verifyToken, authMiddleware.isUserOrAdmin, PropertyController.updateProperty);
router.delete('/properties/:id', authMiddleware.verifyToken, authMiddleware.isUserOrAdmin, PropertyController.deleteProperty);

// --- CATEGORY ---
router.get('/categories', CategoryController.getAllCategories);

// --- BOOKING ---
router.post('/bookings', authMiddleware.verifyToken, BookingController.createBooking);
router.get('/bookings/user/:userId', authMiddleware.verifyToken, BookingController.getUserBookings);
router.get('/bookings/host', authMiddleware.verifyToken, BookingController.getHostBookings);
router.put('/bookings/:id', authMiddleware.verifyToken, authMiddleware.isUserOrAdmin, BookingController.updateStatus); // Host confirm

// --- REVIEW ---
router.post('/reviews', authMiddleware.verifyToken, ReviewController.addReview);
router.get('/reviews/property/:propertyId', ReviewController.getReviewsByProperty);

// --- CHAT ---
router.get('/chat/messages/:userId1/:userId2', authMiddleware.verifyToken, ChatController.getMessages);

module.exports = router;
