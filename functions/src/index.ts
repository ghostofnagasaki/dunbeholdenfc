import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const onNewPost = functions.firestore
    .document('posts/{postId}')
    .onCreate(async (snapshot, context) => {
        const post = snapshot.data();
        const postId = context.params.postId;

        const message = {
            notification: {
                title: 'New Post',
                body: post.title || 'Check out our new post!',
            },
            data: {
                postId: postId,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            topic: 'new_posts',
        };

        try {
            const response = await admin.messaging().send(message);
            console.log('Successfully sent message:', response);
            return {success: true};
        } catch (error) {
            console.log('Error sending message:', error);
            return {success: false};
        }
    }); 