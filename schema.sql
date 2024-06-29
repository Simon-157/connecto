CREATE TABLE User (
    user_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(255),
    bio TEXT,
    skills JSON,
    location GEOMETRY,
    role ENUM('Student', 'Professional') NOT NULL
);

CREATE TABLE Connection (
    connection_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    connected_user_id VARCHAR(255),
    status ENUM('Pending', 'Accepted', 'Rejected') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (connected_user_id) REFERENCES User(user_id)
);

CREATE TABLE Message (
    message_id VARCHAR(255) PRIMARY KEY,
    sender_id VARCHAR(255),
    receiver_id VARCHAR(255),
    content TEXT NOT NULL,
    timestamp DATETIME NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES User(user_id),
    FOREIGN KEY (receiver_id) REFERENCES User(user_id)
);

CREATE TABLE Media (
    media_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    file_path VARCHAR(255) NOT NULL,
    file_type ENUM('Image', 'Video') NOT NULL,
    timestamp DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Notification (
    notification_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    type VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    timestamp DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Event (
    event_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Feedback (
    feedback_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    rating INT NOT NULL,
    comments TEXT NOT NULL,
    timestamp DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);


CREATE TABLE JobFeed (
    feed_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    type ENUM('Mentorship', 'Internship', 'Job') NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    posted_date DATETIME NOT NULL,
    salary_range VARCHAR(255),
    requirements JSON,
    job_type ENUM('Fulltime', 'Remote', 'Partime'),
    company_details TEXT,
    company_logo VARCHAR(255),
    background_picture VARCHAR(255),
    location VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);
