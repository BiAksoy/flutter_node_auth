const jwt = require("jsonwebtoken");

const auth = (req, res, next) => {
  try {
    const token = req.header("x-auth-token");

    if (!token) {
      return res.status(401).json({ message: "No authentication token" });
    }

    const verified = jwt.verify(token, "passwordKey");

    if (!verified) {
      return res.status(401).json({ message: "Token verification failed" });
    }

    req.user = verified.id;
    next();
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = auth;
