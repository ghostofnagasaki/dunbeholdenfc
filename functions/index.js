'use strict';

// Import Firebase Admin SDK and Functions v2
const admin = require('firebase-admin');
const {onDocumentCreated} = require('firebase-functions/v2/firestore');
const {logger} = require('firebase-functions');

// Initialize Firebase Admin
admin.initializeApp();

/**
 * Cloud Function to send notification when a new post is created
 */
exports.sendNotificationOnNewPost = onDocumentCreated(
    'posts/{postId}',
    async (event) => {
      // Get the post data
      const post = event.data?.data();
      logger.info('New post created:', post);

      if (!post) {
        logger.error('No data found in the created document.');
        return null;
      }

      // Prepare the notification message
      const message = {
        notification: {
          title: 'New Post from Dunbeholden FC',
          body: post.title || 'Check out our latest update!',
        },
        data: {
          route: '/news-detail',
          postId: event.params.postId,
        },
        topic: 'news', // This matches the topic we subscribed to in the app
      };

      logger.info('Preparing to send notification:', message);

      try {
        // Send the notification
        const response = await admin.messaging().send(message);
        logger.info('Successfully sent notification:', response);
        return {success: true, messageId: response};
      } catch (error) {
        logger.error('Error sending notification:', error);
        throw new Error('Failed to send notification: ' + error.message);
      }
    },
);
