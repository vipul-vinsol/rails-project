class Vote {
  constructor(nodeSelector) {
    this.element = document.querySelector(nodeSelector);
  }

  init() {
    this.element.addEventListener('ajax:success', function(data) {
      console.log(data);
      let response = data.detail[0];
      if(response.success) {
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