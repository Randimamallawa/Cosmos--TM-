const router = require('express').Router();
const User = require('../controllers/user');

// Route: GET /user
router.post('/login', User.getId);
router.post('/register', User.create);
router.get('/ownWorkflows',User.authenticateToken, User.ownWorkflows);


module.exports = router;
