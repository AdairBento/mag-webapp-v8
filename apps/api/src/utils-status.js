const RENTAL_STATUSES = {
  PENDING: "pending",
  CONFIRMED: "confirmed",
  COMPLETED: "completed",
  CANCELED: "canceled",
};

function isValidStatus(status) {
  return Object.values(RENTAL_STATUSES).includes(status);
}

function isBlockingStatus(status) {
  return status === "confirmed";
}

module.exports = {
  RENTAL_STATUSES,
  isValidStatus,
  isBlockingStatus,
};
// touch
