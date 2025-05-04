var entrants = new Vue({
  el: '#entrant',
  data: {
    api: {
      campaigns: {},
      countries: {},
      url: '',
    },
    entrant: {
      campaign_id: '',
      email: '',
      message: '',
      hash: null,
      errors: [],
      clerk: '',
      nationality: '',
      questionnaire: [],
      resended: false,
    },
    current_campaign: {
      id: '',
      campaign_type: '',
    },
  },
  computed: {
    isNextDisabled: function() {
      return !(this.entrant.hash);
    },
    isSendEmailDisabled: function() {
      if(this.entrant.email === '') {
        this.entrant.errors = [];
        this.entrant.resended = false;
      };
      const expression = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return !expression.test(this.entrant.email.toLowerCase()) || this.entrant.campaign_id == '';
    },
  },
  watch: {
    'entrant.campaign_id': function(newCampaignId) {
      this.current_campaign.id = newCampaignId;
      const selectedCampaign = this.api.campaigns.find(element => element.id === newCampaignId);
      if (selectedCampaign) {
        this.current_campaign.campaign_type = selectedCampaign.campaign_type;
      }
    },
  },
  methods: {
    checkEmail: function() {
      this.entrant.errors = [];
      axios
        .post('/api/entrants/check_email', {email: this.entrant.email, campaign_id: this.current_campaign.id})
        .then(response => {
          if(response.data.status == 'failed') {
            this.entrant.errors.push({element: 'email', message: 'Адрес электронной почты уже зарегистрирован в системе', level: 'red'});
          }
          if(response.data.status == 'success'){
            this.entrant.errors = [];
            this.sendWelcomeEmail();
          }
        })
    },
    sendWelcomeEmail: function() {
      axios
        .post('/api/entrants', { campaign_id: this.entrant.campaign_id, email: this.entrant.email, clerk: this.entrant.clerk, nationality: this.entrant.nationality })
        .then(response => {
          if(response.data.status == 'success') {
            this.entrant.hash = response.data.hash;
            this.entrant.entrant_id = response.data.id;
            console.log('личный кабинет создан');
            this.api.url = window.location.hostname + '/' + this.entrant.hash;
          }
          if(response.data.status == 'failed') {
            console.log('что-то пошло не так');
          }
      })
    },
    resendEmail: function(){
      this.entrant.errors = [];
      axios
        .post('/api/entrants/resend_email', {email: this.entrant.email})
        .then(response => {
          console.log(response.data);
          if(response.data.status == 'success'){
            this.entrant.resended = true;
          }
          if(response.data.status == 'failed') {
            this.entrant.resended = false;
          }
        })
    },
    checkForm: function(e) {
      this.entrant.errors = [];
      if(this.entrant.email == '') this.entrant.errors.push({element: 'email', message: 'Необходимо указать адрес электронной почты', level: 'red'});
      if(this.entrant.campaign_id == '') this.entrant.errors.push({element: 'campaign_id', message: 'Необходимо выбрать приемную кампанию', level: 'red'});
      if(this.entrant.errors.length == 0) return true;
      e.preventDefault();
    },
    findErrorMessage: function(fieldName) {
      var message = '';
      this.entrant.errors.find(function(element) {
        if(fieldName == element.element) {
          message = element.message;
        }
      });
      return message;
    },
  },
  created: function() {
    axios
      .get('/api/campaigns')
      .then(response => {
        this.api.campaigns = response.data.campaigns
        if(this.api.campaigns.length === 1) {
          this.entrant.campaign_id = this.api.campaigns[0].id;
          this.current_campaign.id = this.api.campaigns[0].id;
          this.current_campaign.campaign_type = this.api.campaigns[0].campaign_type;
        };
      });
    axios
      .get('/api/dictionaries/18')
      .then(response => (this.api.countries = response.data.dictionary.items));
    },
  mounted: function () {
    this.entrant.clerk = this.$refs.clerk.dataset.clerk;
    this.api.hostname = window.location.hostname;
  },
})
