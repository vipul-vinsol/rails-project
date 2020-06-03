class Vote {
  constructor(nodeSelector) {
    this.element = document.querySelector(nodeSelector);
  }

  init() {
    // FIXME_AB: lets also add jquery ajax loader globally on the document, so that any ajax request sent by the page shows loader
    this.element.addEventListener('ajax:success', function(data) {
      console.log(data);
      let response = data.detail[0];
      if(response.success) {
        // FIXME_AB: shouldn't this be in scope of this.element. Instead of whole page search. This way we can also have multiple instances
        document.getElementById('vote-counter').innerHTML = response.vote_count;
      } else {
        alert(JSON.stringify(response.message));
      }
    });

    this.element.addEventListener('ajax:error', function(data) {
      console.log(data);
    });
  }
}

export default Vote;
