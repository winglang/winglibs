const axios = require('axios');
const dayjs = require('dayjs');

const channelWebhook = 'https://hooks.slack.com/services/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';

/**
 * Handler that will be called during the execution of a PostLogin flow.
 *
 * @param {Event} event - Details about the user and the context in which they are logging in.
 * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
 */
exports.onExecutePostLogin = async (event, api) => {
  console.info('user_id: ', event.user.user_id);
  console.info('client_id: ', event.client.client_id);

  if (event.client.name !== 'Docs') {
    console.info('Not logging into Docs, so not notifying anything');
    return;
  }

  const user = event.user;
  if (dayjs(event.user.created_at) < dayjs().subtract(1, 'minute') || event.stats.logins_count > 1) {
    return;
  }

  const encodedUserUri = Buffer.from(encodeURIComponent(user.user_id)).toString('base64').replace(/=/gi, '');

  console.info({user});
  const prompt = `A new user, ${user.email}, has tried logging into the Docs site!`;
  await axios.post(channelWebhook, {
    text: prompt,
    blocks: [
      {
        type: 'section',
        text: {
          type: 'plain_text',
          text: 'Should this user have access to the Wing Alpha?'
        }
      },
      {
        type: 'section',
        text: {
          type: 'plain_text',
          text: prompt
        }
      },
      {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: `https://manage.auth0.com/dashboard/us/dev-9zrd68w6/users/${encodedUserUri}`
        }
      }
    ]
  });

};
