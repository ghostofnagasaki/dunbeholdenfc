'use strict';

const admin = require('firebase-admin');
const {onDocumentCreated} = require('firebase-functions/v2/firestore');
const {logger} = require('firebase-functions');
const functions = require('firebase-functions');

admin.initializeApp();

exports.sendNotificationOnNewPost = onDocumentCreated(
    'posts/{postId}',
    async (event) => {
      const post = event.data?.data();
      logger.info('New post created:', post);

      if (!post) {
        logger.error('No data found in the created document.');
        return null;
      }

      const message = {
        notification: {
          title: 'Dunbeholden FC',
          body: post.title || 'Check out our latest update!',
        },
        data: {
          route: '/news-detail',
          postId: event.params.postId,
        },
        topic: 'news',
      };

      logger.info('Preparing to send notification:', message);

      try {
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

exports.sendMatchCommentaryNotification = functions.firestore
    .document('matches/{matchId}')
    .onUpdate(async (change, context) => {
      const matchData = change.after.data();
      const previousData = change.before.data();

      // Check if new commentary was added
      if (matchData.commentary?.length > (previousData.commentary?.length || 0)) {
        // Get the latest commentary (last item in array)
        const latestCommentary = matchData.commentary[matchData.commentary.length - 1];

        const message = {
          notification: {
            title: 'Match Update',
            body: latestCommentary.text,
          },
          data: {
            type: 'match_commentary',
            matchId: context.params.matchId,
            score: latestCommentary.score,
          },
          topic: 'match_commentary',
          android: {
            priority: 'high',
            notification: {
              channel_id: 'live_match_channel',
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
      }

      // Check if match went live
      if (matchData.isLive && !previousData.isLive) {
        const message = {
          notification: {
            title: 'Match Starting',
            body: `${matchData.homeTeam} vs ${matchData.awayTeam}`,
          },
          data: {
            type: 'match_live',
            matchId: context.params.matchId,
            homeTeam: matchData.homeTeam,
            awayTeam: matchData.awayTeam,
            competition: matchData.competition,
          },
          topic: 'live_matches',
        };

        return admin.messaging().send(message);
      }

      return null;
    });
