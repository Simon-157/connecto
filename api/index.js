const express = require('express');
const admin = require('firebase-admin');
const bodyParser = require('body-parser');

const serviceAccount = require('./firebaseService.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
//   databaseURL: 'https://project-id.firebaseio.com'
});

const db = admin.firestore();
const app = express();

app.use(bodyParser.json());

const handleError = (res, error) => {
  console.error('Error:', error);
  res.status(500).send(error.message || 'Internal Server Error');
};


app.get('/', (req, res) => {
  res.send('Welcome to Connecto API!');
});

// Create a job feed
app.post('/jobfeeds', async (req, res) => {
  try {
    const jobFeedData = req.body;
    await db.collection('jobfeeds').doc(jobFeedData.feedId).set(jobFeedData);
    res.status(201).send('Job feed created successfully');
  } catch (error) {
    handleError(res, error);
  }
});


// Batch create job feeds
app.post('/jobfeeds/batch', async (req, res) => {
  try {
    const jobFeeds = req.body;
    const batch = db.batch();
    
    jobFeeds.forEach(jobFeed => {
      const jobFeedRef = db.collection('jobfeeds').doc(jobFeed.feedId);
      batch.set(jobFeedRef, jobFeed);
    });
    
    await batch.commit();
    res.status(201).send('Batch job feeds created successfully');
  } catch (error) {
    handleError(res, error);
  }
});

// Get all job feeds
app.get('/jobfeeds', async (req, res) => {
  try {
    const snapshot = await db.collection('jobfeeds').get();
    const jobFeeds = [];
    snapshot.forEach(doc => {
      jobFeeds.push(doc.data());
    });
    res.status(200).json(jobFeeds);
  } catch (error) {
    handleError(res, error);
  }
});

// Get a single job feed
app.get('/jobfeeds/:feedId', async (req, res) => {
  try {
    const feedId = req.params.feedId;
    const doc = await db.collection('jobfeeds').doc(feedId).get();
    if (!doc.exists) {
      res.status(404).send('Job feed not found');
    } else {
      res.status(200).json(doc.data());
    }
  } catch (error) {
    handleError(res, error);
  }
});

// Update a job feed
app.put('/jobfeeds/:feedId', async (req, res) => {
  try {
    const feedId = req.params.feedId;
    const jobFeedData = req.body;
    await db.collection('jobfeeds').doc(feedId).update(jobFeedData);
    res.status(200).send('Job feed updated successfully');
  } catch (error) {
    handleError(res, error);
  }
});

// Delete a job feed
app.delete('/jobfeeds/:feedId', async (req, res) => {
  try {
    const feedId = req.params.feedId;
    await db.collection('jobfeeds').doc(feedId).delete();
    res.status(200).send('Job feed deleted successfully');
  } catch (error) {
    handleError(res, error);
  }
});

// Company CRUD Operations

// Create a company
app.post('/companies', async (req, res) => {
  try {
    const companyData = req.body;
    await db.collection('companies').doc(companyData.companyId).set(companyData);
    res.status(201).send('Company created successfully');
  } catch (error) {
    handleError(res, error);
  }
});


// Batch create companies
app.post('/companies/batch', async (req, res) => {
  try {
    const companies = req.body;
    const batch = db.batch();
    
    companies.forEach(company => {
      const companyRef = db.collection('companies').doc(company.companyId);
      batch.set(companyRef, company);
    });
    
    await batch.commit();
    res.status(201).send('Batch companies created successfully');
  } catch (error) {
    handleError(res, error);
  }
});


// Get all companies
app.get('/companies', async (req, res) => {
  try {
    const snapshot = await db.collection('companies').get();
    const companies = [];
    snapshot.forEach(doc => {
      companies.push(doc.data());
    });
    res.status(200).json(companies);
  } catch (error) {
    handleError(res, error);
  }
});

// Get a single company
app.get('/companies/:companyId', async (req, res) => {
  try {
    const companyId = req.params.companyId;
    const doc = await db.collection('companies').doc(companyId).get();
    if (!doc.exists) {
      res.status(404).send('Company not found');
    } else {
      res.status(200).json(doc.data());
    }
  } catch (error) {
    handleError(res, error);
  }
});

// Update a company
app.put('/companies/:companyId', async (req, res) => {
  try {
    const companyId = req.params.companyId;
    const companyData = req.body;
    await db.collection('companies').doc(companyId).update(companyData);
    res.status(200).send('Company updated successfully');
  } catch (error) {
    handleError(res, error);
  }
});

// Delete a company
app.delete('/companies/:companyId', async (req, res) => {
  try {
    const companyId = req.params.companyId;
    await db.collection('companies').doc(companyId).delete();
    res.status(200).send('Company deleted successfully');
  } catch (error) {
    handleError(res, error);
  }
});

// Event CRUD Operations

// Create an event
app.post('/events', async (req, res) => {
  try {
    const eventData = req.body;
    await db.collection('events').doc(eventData.eventId).set(eventData);
    res.status(201).send('Event created successfully');
  } catch (error) {
    handleError(res, error);
  }
});


// Batch create events
app.post('/events/batch', async (req, res) => {
  try {
    const events = req.body;
    const batch = db.batch();
    
    events.forEach(event => {
      const eventRef = db.collection('events').doc(event.eventId);
      batch.set(eventRef, event);
    });
    
    await batch.commit();
    res.status(201).send('Batch events created successfully');
  } catch (error) {
    handleError(res, error);
  }
});



// Get all events
app.get('/events', async (req, res) => {
  try {
    const snapshot = await db.collection('events').get();
    const events = [];
    snapshot.forEach(doc => {
      events.push(doc.data());
    });
    res.status(200).json(events);
  } catch (error) {
    handleError(res, error);
  }
});

// Get a single event
app.get('/events/:eventId', async (req, res) => {
  try {
    const eventId = req.params.eventId;
    const doc = await db.collection('events').doc(eventId).get();
    if (!doc.exists) {
      res.status(404).send('Event not found');
    } else {
      res.status(200).json(doc.data());
    }
  } catch (error) {
    handleError(res, error);
  }
});

// Update an event
app.put('/events/:eventId', async (req, res) => {
  try {
    const eventId = req.params.eventId;
    const eventData = req.body;
    await db.collection('events').doc(eventId).update(eventData);
    res.status(200).send('Event updated successfully');
  } catch (error) {
    handleError(res, error);
  }
});

// Delete an event
app.delete('/events/:eventId', async (req, res) => {
  try {
    const eventId = req.params.eventId;
    await db.collection('events').doc(eventId).delete();
    res.status(200).send('Event deleted successfully');
  } catch (error) {
    handleError(res, error);
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
