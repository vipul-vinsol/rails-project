require('./default');
import Vote from './vote';
const UPVOTE_SELECTOR = "#upvote";
const DOWNVOTE_SELECTOR = "#downvote";

document.addEventListener("turbolinks:load", () => {
  let upvote = new Vote(UPVOTE_SELECTOR);
  let downvote = new Vote(DOWNVOTE_SELECTOR);

  upvote.init();
  downvote.init();
});