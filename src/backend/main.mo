import Array "mo:core/Array";
import Int "mo:core/Int";
import Map "mo:core/Map";
import Order "mo:core/Order";
import Runtime "mo:core/Runtime";
import Text "mo:core/Text";
import Time "mo:core/Time";

actor {
  type ContactSubmission = {
    name : Text;
    email : Text;
    message : Text;
    timestamp : Time.Time;
  };

  module ContactSubmission {
    public func compareByTimestamp(sub1 : ContactSubmission, sub2 : ContactSubmission) : Order.Order {
      Int.compare(sub1.timestamp, sub2.timestamp);
    };
  };

  let submissions = Map.empty<Text, ContactSubmission>();

  public shared ({ caller }) func submitContact(name : Text, email : Text, message : Text) : async () {
    if (message.isEmpty()) { Runtime.trap("Message cannot be empty.") };
    let timestamp = Time.now();
    let submission : ContactSubmission = {
      name;
      email;
      message;
      timestamp;
    };
    submissions.add(timestamp.toText(), submission);
  };

  public query ({ caller }) func getAllSubmissions() : async [ContactSubmission] {
    submissions.values().toArray().sort(ContactSubmission.compareByTimestamp);
  };
};
