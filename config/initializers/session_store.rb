# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_photo_session',
  :secret      => '86984b9d196b1b1273c2ed58bb7ecc9bdccb1b32704cda9bafa54e72ad1ce6bb01e7bcbae5247dc608f03ba8252b86bce260253f746def675dc6481d549c8cf0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
