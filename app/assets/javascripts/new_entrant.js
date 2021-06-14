var entrants = new Vue({
  el: '#entrant_application',
  data: {
    api: {
      campaigns: null
    },
    campaignId: '',
    entrantApplicationId: null,
    email: '',
    pin: '',
    response: null,
    error: null,
    files: '',
    message: '',
    emailConfirmed: false,
    hash: '',
    errors: [],
    attachments: [
    {
      id: null,
      documentType: '',
      mimeType: '',
      dataHash: '',
      status: null,
      merged: false,
      template: false,
      documentId: null,
      filename: ''
    }
    ]
  },
  computed: {
    isNextDisabled: function() {
      if(this.emailConfirmed && this.files && this.hash) {
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
    checkPin: function() {
      if(this.pin.length == 4) {
        console.log(this.pin);
        this.confirmEmail();
      };
    },
    changeCampaign: function() {
      console.log(this.campaign_id)
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
    checkForm: function(e) {
      this.errors = [];
      if(this.files == '') this.errors.push({element: 'files', message: 'Необходимо прикрепить сканы согласий на обработку персональных данных', level: 'red'});
      if(this.email == '') this.errors.push({element: 'email', message: 'Необходимо указать адрес электронной почты', level: 'red'});
      if(this.pin == '' && !this.skip) this.errors.push({element: 'pin', message: 'Необходимо ввести код', level: 'red'});
      if(this.campaign_id == '') this.errors.push({element: 'campaign_id', message: 'Необходимо выбрать приемную кампанию', level: 'red'});
      if(this.errors.length == 0) return true;
      e.preventDefault();
    },
    sendCode: function() {
      this.errors = [];
      axios
        .post('/api/entrant_applications', {campaignId: this.campaignId, email: this.email})
        .then(response => {
          if(response.data.status == 'success') {
            this.hash = response.data.hash;
            this.entrantApplicationId = response.data.id
            $('#email_code_field').foundation('reveal', 'open');
          }
          if(response.data.status == 'faild') {
            this.errors.push({element: 'email', message: 'Заявление с таким адресом электронной почты уже подано', level: 'red'});
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
    handleFiles: function(){
      this.files = this.$refs.files.files;
      let formData = new FormData();
      for( var i = 0; i < this.files.length; i++ ){
        let file = this.files[i];
        formData.append('files[' + i + ']', file);
      }
      axios.post( '/api/attachments',
        formData,
        {
          headers: {
              'Content-Type': 'multipart/form-data'
          }
        }
      ).then(function(){
        this.attachments = response.data.attachments
      })
      .catch(function(){
        console.log('FAILURE!!');
      });
    },
    confirmEmail: function () {
      axios
        .put( '/api/entrant_applications/' + this.hash + '/check_pin', { hash: this.hash, pin: this.pin } )
        .then(response => {
          console.log(response)
          if(response.data.status == 'success') {
            this.emailConfirmed = true;
            this.message = 'код подтверждения успешно проверен';
            $('#email_code_field').foundation('reveal', 'close');
          }
          else
          {
            this.emailConfirmed = false;
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
            this.emailConfirmed = true;
            this.message = 'отказ от проверки подтвержден';
            $('#email_code_field').foundation('reveal', 'close');
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
