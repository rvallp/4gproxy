const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser.json());

app.post('/sms/push', (req, res) => {
  const smsMessage = req.body;
  // your sms message
  console.log(smsMessage);

  res.status(200).send('got sms');
});

app.listen(7001, () => {
  console.log('started server');
});