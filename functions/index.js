'use strict';

// Import Firebase Admin SDK and Functions v2
const admin = require('firebase-admin');
const {onDocumentCreated} = require('firebase-functions/v2/firestore');
const {logger} = require('firebase-functions');
const functions = require('firebase-functions');

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
          title: 'Dunbeholden FC',
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

exports.sendPostNotification = functions.firestore
  .document('posts/{postId}')
  .onCreate(async (snap, context) => {
    const post = snap.data();
    
    const message = {
      notification: {
        title: post.category === 'announcement' ? 'New Announcement' : 'New Post',
        body: post.title,
      },
      data: {
        postId: context.params.postId,
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      },
      topic: 'posts',
      android: {
        priority: 'high',
        notification: {
          channel_id: 'high_importance_channel',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
          },
        },
      },
    };

    return admin.messaging().send(message);
  });
