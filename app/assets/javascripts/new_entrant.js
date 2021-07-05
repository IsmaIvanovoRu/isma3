var entrants = new Vue({
  el: '#entrant_application',
  data: {
    api: {
      campaigns: null
    },
    campaign_id: '',
    entrant_application_id: null,
    email: '',
    pin: '',
    response: null,
    error: null,
    files: '',
    dataset: '',
    message: '',
    email_confirmed: false,
    hash: '',
    errors: [],
    attachments: [],
    clerk: '',
  },
  computed: {
    isNextDisabled: function() {
      if(this.email_confirmed && this.hash) {
        return false
      }
      else {
        return true
      }
    },
    isSendCodeDisabled: function() {
      const expression = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return !expression.test(String(this.email).toLowerCase());
    }
  },
  methods: {
    sendWelcomeEmail: function() {
      axios
        .put('/api/entrant_applications/' + this.hash + '/send_welcome_email', {id: this.hash})
        .then(response => {
          console.log(response.data.message);
        })
    },
    findCampaign: function(campaignId) {
      var find_campaign = null;
      this.api.campaigns.find(function(element) {
        if(campaignId == element.id){
          find_campaign = element;
        };
      });
      return find_campaign;
    },
    checkPin: function() {
      if(this.pin.length == 4) {
        console.log(this.pin);
        this.confirmEmail();
      };
    },
    checkForm: function(e) {
      this.errors = [];
      if(this.email == '') this.errors.push({element: 'email', message: 'Необходимо указать адрес электронной почты', level: 'red'});
      if(this.campaign_id == '') this.errors.push({element: 'campaign_id', message: 'Необходимо выбрать приемную кампанию', level: 'red'});
      if(this.errors.length == 0) return true;
      e.preventDefault();
    },
    checkEmail: function() {
      this.errors = [];
      axios
        .post('/api/entrant_applications/check_email', {campaign_id: this.campaign_id, email: this.email})
        .then(response => {
          if(response.data.status == 'faild') {
            this.errors.push({element: 'email', message: 'Заявление с таким адресом электронной почты уже подано', level: 'red'});
          }
          if(response.data.status == 'success'){
            $('#email_code_field').foundation('reveal', 'open');
            this.sendCode();
          }
        })
    },
    sendCode: function() {
      axios
        .post('/api/entrant_applications', {campaign_id: this.campaign_id, email: this.email, clerk: this.$refs.clerk.dataset.clerk})
        .then(response => {
          if(response.data.status == 'success') {
            this.hash = response.data.hash;
            this.entrant_application_id = response.data.id
          }
          if(response.data.status == 'faild') {
            console.log('что-то пошло не так')
          }
      })
    },
    findErrorMessage: function(fieldName) {
      var message = '';
      this.errors.find(function(element) {
        if(fieldName == element.element) {
          message = element.message;
        }
      });
      return message;
    },
    confirmEmail: function () {
      axios
        .put( '/api/entrant_applications/' + this.hash + '/check_pin', { hash: this.hash, pin: this.pin } )
        .then(response => {
          if(response.data.status == 'success') {
            this.email_confirmed = true;
            this.message = 'код подтверждения успешно проверен';
            $('#email_code_field').foundation('reveal', 'close');
            this.sendWelcomeEmail();
          }
          else
          {
            this.email_confirmed = false;
            this.message = 'код подтверждения введен неверно';
            this.errors.push({element: 'pin', message: 'Код подтверждения введен неверно', level: 'red'});
          }
        })
        .catch(function (error) {
          console.log(error)
        });
    },
    checkEmailDecline: function() {
      axios
        .put( '/api/entrant_applications/' + this.hash + '/remove_pin', { hash: this.hash } )
        .then(response => {
          if(response.data.status == 'success') {
            this.email_confirmed = true;
            this.message = 'отказ от проверки подтвержден';
            $('#email_code_field').foundation('reveal', 'close');
            this.sendWelcomeEmail();
          }
        })
        .catch(function (error) {
          console.log(error)
        });
    }
  },
  mounted: function() {
    axios
      .get('/api/campaigns')
      .then(response => (this.api.campaigns = response.data.campaigns));
  }
})
