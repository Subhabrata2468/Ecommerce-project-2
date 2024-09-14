const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const User = require('./models/User'); // Import your User model
require('dotenv').config();

async function createDefaultAdmin() {
  try {
    // Check if the admin user already exists
    let adminUser = await User.findOne({ email: process.env.ADMIN_EMAIL });
    if (!adminUser) {
      // If not, create one
      const hashedPassword = await bcrypt.hash(process.env.ADMIN_PASSWORD, 10);
      adminUser = new User({
        userName: process.env.ADMIN_USERNAME,
        email: process.env.ADMIN_EMAIL,
        password: hashedPassword,
        role: 'admin'
      });
      await adminUser.save();
      console.log('Admin user created successfully');
    } else {
      console.log('Admin user already exists');
    }
  } catch (error) {
    console.error('Error creating admin user:', error);
  }
}

module.exports = createDefaultAdmin;
