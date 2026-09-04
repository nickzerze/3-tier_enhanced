import React from 'react';

const Home = () => (
  <main>
    <h1 style={{ color: 'white' }}>AWS Secure 3-Tier Architecture</h1>
    <p style={{ color: 'white', maxWidth: '60rem', lineHeight: 1.6 }}>
      Internet → AWS WAF → Public HTTPS ALB → Web Auto Scaling Group →
      Internal ALB → Application Auto Scaling Group → Amazon RDS MySQL
    </p>
  </main>
);

export default Home;
