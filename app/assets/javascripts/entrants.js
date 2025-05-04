var entrants = new Vue({
  el: '#entrant',
  data: {
    api: {
      hash: window.document.location.pathname.split('/')[2],
      current_tab: 'common',
      dictionaries: {
        campaign: {},
        identity_document_categories: [],
        regions: [],
        languages: [
          'Английский',
          'Французский',
          'Немецкий',
        ],
        benefit_document_categories: [
          {
            name: "Справка об установлении инвалидности"
          },
          {
            name: "Документ, подтверждающий принадлежность к детям-сиротам и детям, оставшимся без попечения родителей"
          },
          {
            name: "Документ, подтверждающий принадлежность к ветеранам боевых действий"
          },
          {
            name: "Документ, подтверждающий наличие только одного родителя - инвалида I группы и принадлежность к числу малоимущих семей"
          },
          {
            name: "Документ, подтверждающий принадлежность родителей и опекунов к погибшим в связи с исполнением служебных обязанностей"
          },
          {
            name: "Документ, подтверждающий принадлежность к сотрудникам государственных органов Российской Федерации"
          },
          {
            name: "Документ, подтверждающий участие в работах на радиационных объектах или воздействие радиации"
          },
          {
            name: "Документ, подтверждающий право поступления по отдельной квоте"
          },
        ],
        olympic_document_categories: [
          {
            name: "Диплом победителя/призера олимпиады школьников"
          },
          {
            name: "Диплом победителя/призера всероссийской олимпиады школьников"
          }
        ],
        olympic_profiles: [
          {
            name: "химия"
          },
          {
            name: "биология"
          },
          {
            name: "физика"
          },
          {
            name: "русский язык"
          },
          {
            name: "медицина"
          },
        ],
        education_document_categories: [
          {
            name: "Аттестат о среднем общем образовании"
          },
          {
            name: "Диплом о среднем профессиональном образовании"
          },
          {
            name: "Диплом бакалавра"
          },
          {
            name: 'Диплом специалиста'
          },
          {
            name: 'Диплом магистра'
          },
        ],
        other_document_categories: [
          'Свидетельство об аккредитации специалиста',
          'Выписка из итогового протокола заседания аккредитационной комиссии',
          'Сертификат специалиста',
          'Военный билет',
          'Документ о смене фамилии',
          'Иной документ'
        ],
        education_speciality_codes: [
          {
            code: '31.05.01',
            name: 'Лечебное дело'
          },
          {
            code: '31.05.02',
            name: 'Педиатрия'
          },
          {
            code: '31.05.03',
            name: 'Стоматология'
          },
          {
            code: '32.05.01',
            name: 'Медико-профилактическое дело'
          },
          {
            code: '33.05.01',
            name: 'Фармация'
          },
          {
            code: '30.05.01',
            name: 'Медицинская биохимия'
          },
          {
            code: '30.05.02',
            name: 'Медицинская биофизика'
          },
          {
            code: '30.05.03',
            name: 'Медицинская кибернетика'
          },
          {
            code: '37.05.01',
            name: 'Клиническая психология'
          },
          {
            code: '00.00.00',
            name: 'Другая'
          }
        ]
      }
    },
    errors: [],
    files: '',
    dataset: '',
    entrant: {},
  },
  computed: {
    checkEntrantFirstName: function() {
      if(this.entrant.personal.first_name.charAt(0).toUpperCase() + this.entrant.personal.first_name.slice(1).toLowerCase() != this.entrant.personal.first_name) return 'Обычно имя начинается с заглавной буквы, за которой следуют строчные';
    },
    checkEntrantMiddleName: function() {
      if(this.entrant.personal.middle_name.charAt(0).toUpperCase() + this.entrant.personal.middle_name.slice(1).toLowerCase() != this.entrant.personal.middle_name) return 'Обычно отчество начинается с заглавной буквы, за которой следуют строчные';
    },
    checkEntrantLastName: function() {
      if(this.entrant.personal.last_name.charAt(0).toUpperCase() + this.entrant.personal.last_name.slice(1).toLowerCase() != this.entrant.personal.last_name) return 'Обычно фамилия начинается с заглавной буквы, за которой следуют строчные';
    },
    checkContragentFirstName: function() {
      if(this.entrant.contragent.first_name.charAt(0).toUpperCase() + this.entrant.contragent.first_name.slice(1).toLowerCase() != this.entrant.contragent.first_name) return 'Обычно имя начинается с заглавной буквы, за которой следуют строчные';
    },
    checkContragentMiddleName: function() {
      if(this.entrant.contragent.middle_name.charAt(0).toUpperCase() + this.entrant.contragent.middle_name.slice(1).toLowerCase() != this.entrant.contragent.middle_name) return 'Обычно отчество начинается с заглавной буквы, за которой следуют строчные';
    },
    checkContragentLastName: function() {
      if(this.entrant.contragent.last_name.charAt(0).toUpperCase() + this.entrant.contragent.last_name.slice(1).toLowerCase() != this.entrant.contragent.last_name) return 'Обычно фамилия начинается с заглавной буквы, за которой следуют строчные';
    },
    checkBirthDate: function() {
      if(this.entrant.personal.birth_date){
        var numbers = this.entrant.personal.birth_date.split('-');
        var birthYear = Number(numbers[0]);
        var birthMonth = Number(numbers[1]) - 1;
        var birthDay = Number(numbers[2]);
        var message = [];
        var year = (new Date()).getFullYear();
        if(birthYear + birthMonth + birthDay) {
          if(!(Number(numbers[0]) > 0 && Number(numbers[0]) < Number(year))) message.push('Неверный год');
          if(!(Number(numbers[1]) > 0 && Number(numbers[1]) < 13)) message.push('Неверный месяц');
          if(!(Number(numbers[2]) > 0 && Number(numbers[2]) < 32)) message.push('Неверный день');
          return message.join(', ')
        }
      }
    },
    checkContragent: function() {
      if(!this.entrant.contragent.id || !this.entrant.contragent.last_name || !this.entrant.contragent.first_name || !this.entrant.contragent.birth_date || !this.entrant.contragent.identity_document_serie || !this.entrant.contragent.identity_document_number || !this.entrant.contragent.identity_document_date || !this.entrant.contragent.identity_document_issuer || !this.entrant.contragent.email || !this.entrant.contragent.phone || !this.entrant.contragent.address) return 'Необходимо заполнить данные заказчика договора на платную образовательную услугу';
    },
    isDisabled: function() {
      if(this.entrant.stage == 0) {
        return false;
      }
      else {
        return true;
      }
    },
    checkPaidCompetitiveGroups: function(){
      var checkPaidCompetitiveGroups = false;
      this.entrant.competitive_groups.find(function(element) {
        if(element.education_source == 'По договору об оказании платных образовательных услуг') {
          checkPaidCompetitiveGroups = true;
        }
      })
      return checkPaidCompetitiveGroups;
    },
    checkAge: function() {
      var minAge = 18;
      var numbers = this.entrant.personal.birth_date.split('-');
      var birthYear = Number(numbers[0]);
      var birthMonth = Number(numbers[1]) - 1;
      var birthDay = Number(numbers[2]);
      var tempDate = new Date(birthYear + minAge, birthMonth, birthDay);
      return (tempDate <= new Date());
    },
    checkSNILS: function() {
      // Remove any non-digit characters from the SNILS
      var snils = ''
      this.entrant.snils.find(function(element){
        if(element.number != ''){
          snils = String(element.number)
        }
      })
      snils = snils.replace(/\D/g, '');
    
      // Check if the SNILS has the correct length
      if (snils.length > 0 && snils.length !== 11) {
        return 'В номер СНИЛС должно быть 11 цифр';
      }
      if (snils.length === 11) {
        // Calculate the control sum
        const controlSum = snils.slice(0, -2).split('').reduce((sum, digit, index) => sum + digit * (9 - index), 0);
      
        // Check the control sum against the last two digits
        const controlDigits = parseInt(snils.slice(-2), 10);
        const expectedControlDigits = controlSum > 101 ? controlSum % 101 : controlSum;
      
        if (expectedControlDigits !== controlDigits) {
          return 'Контрольная сумма не совпадает, введенное значение не является номером СНИЛС'
        }
      }
    },
    dragOptions: function() {
      return {
        animation: 200,
        group: "description",
        disabled: false,
        ghostClass: "ghost"
      };
    },
  },
  methods: {
    checkMove: function(event) {
      return (event.draggedContext.element.source === event.relatedContext.element.source);
    },
    fillPriority: function(items) {
      for(var i = 0; i < items.length; i++) {
        items[i].priority = i + 1;
        }
    },
    egeDate: function(competitive_group_id) {
      var egeDate = false;
      const currentDate = new Date();
      var endDate = null;
      this.api.dictionaries.campaign.term_admissions.find(function(element) {
        if(element.competitive_group_id == competitive_group_id && element.name == 'Прием заявлений и документов без прохождения ДВИ и ВИ вуза') {
          endDate = new Date(element.end_date)
        }
      })
      if(currentDate > endDate) {
          egeDate = true;
        }
      return egeDate;
    },
    fillContragent: function() {
      this.entrant.contragent.last_name = this.entrant.personal.last_name;
      this.entrant.contragent.first_name = this.entrant.personal.first_name;
      this.entrant.contragent.middle_name = this.entrant.personal.middle_name;
      this.entrant.contragent.birth_date = this.entrant.personal.birth_date;
      this.entrant.contragent.email = this.entrant.contact_information.email;
      this.entrant.contragent.phone = this.entrant.contact_information.phone;
      this.entrant.contragent.address = this.entrant.contact_information.address;
      this.entrant.contragent.identity_document_number = this.entrant.identity_documents[0].number;
      this.entrant.contragent.identity_document_serie = this.entrant.identity_documents[0].serie;
      this.entrant.contragent.identity_document_date = this.entrant.identity_documents[0].date;
      this.entrant.contragent.identity_document_issuer = this.entrant.identity_documents[0].issuer;
      this.sendData('contragent', this.entrant.contragent);
    },
    withdrawCount: function() {
      var withdrawCount = 0;
      this.entrant.attachments.find(function(element) {
        if(element.document_type == 'withdraw_application' && !element.template) withdrawCount++;
      });
      return withdrawCount;
    },
    generateTemplates: function() {
      this.generateEntrantApplicationTemplates();
    },
    generateEntrantApplicationTemplates: function() {
      axios
      .put('/api/entrants/' + this.entrant.hash + '/generate_entrant_application', {id: this.entrant.hash})
      .then(response => {
        console.log(response.data.message);
        this.entrant.attachments = response.data.attachments;
      });
    },
    isApplicable: function(competitiveGroup) {
      if(competitiveGroup.education_source == 'По договору об оказании платных образовательных услуг' && competitiveGroup.entrance_category == 'Для иностранных граждан — обучение на русском языке' && this.entrant.nationality != 'РОССИЯ') {
        return true;
      };
      if(competitiveGroup.education_source == 'По договору об оказании платных образовательных услуг' && competitiveGroup.entrance_category == 'Для иностранных граждан — обучение на английском языке' && this.entrant.nationality != 'РОССИЯ') {
        return true;
      };
      if(competitiveGroup.education_source == 'Отдельная квота' && competitiveGroup.entrance_category == null && this.entrant.questionnaire['special']) {
        return true;
      };
      if(competitiveGroup.education_source == 'Особая квота' && competitiveGroup.entrance_category == null && this.entrant.questionnaire['benefit']) {
        return true;
      };
      if(competitiveGroup.education_source == 'Основные места в рамках КЦП' || (competitiveGroup.education_source == 'По договору об оказании платных образовательных услуг' && competitiveGroup.entrance_category == null)) {
        return true;
      };
      if(competitiveGroup.education_source == 'Целевая квота' && this.entrant.campaign.campaign_type === 'Прием на подготовку кадров высшей квалификации') {
        var max = 1;
        if(this.entrant.competitive_groups.filter(function(group) { return group.education_source == 'Целевая квота'; }).length > max) {
          if(this.findCompetitiveGroup(competitiveGroup.id)) {
            return true;
          } else {
            return false;
          };
        } else {
          return true;
        };
      };
      return false;
    },
    findAchievement: function(institutionAchievementId) {
      var findAchievement = null;
      this.entrant.achievement_ids.find(function(element) {
        if(element == institutionAchievementId){
          findAchievement = element;
        };
      });
      return findAchievement;
    },
    findAttachment: function(document_id, document_type, template) {
      var findAttachment = null;
      this.entrant.attachments.find(function(element) {
        if(element.document_id == document_id && element.document_type == document_type && element.template == template){
          findAttachment = element;
        };
      });
      return findAttachment;
    },
    findCompetitiveGroup: function(competitive_group_id) {
      var findCompetitiveGroup = false;
      this.entrant.competitive_groups.find(function(competitive_group) {
        if(competitive_group.id == competitive_group_id) {
          findCompetitiveGroup = competitive_group
        };
      });
      return findCompetitiveGroup;
    },
    findTargetOfferIndex: function(competitive_group_id) {
      return this.entrant.target_offer_ids.findIndex(function(target_offer_id){
        return target_offer_id.competitive_group_id == competitive_group_id
      });
    },
    openContragentModal: function(){
      $('#contragent').foundation('reveal', 'open');
    },
    closeContragentModal: function(){
      $('#contragent').foundation('reveal', 'close');
    },
    generateContract: function(competitive_group_id) {
      $('.contract_button').addClass('hide');
      $('#contract_link').removeClass('hide');
      axios
      .put('/api/entrants/' + this.entrant.hash + '/generate_contracts', {id: this.entrant.id, competitive_group_id: competitive_group_id})
      .then(response => {
        console.log(response.data.message);
        this.entrant.attachments = response.data.attachments;
        $('#contract_link').addClass('hide');
        $('.contract_button').removeClass('hide');
      });
    },
    sendData: function(sub, subData, index) {
      let data = {};
      data[sub] = subData;
      axios
      .put('/api/entrants/' + this.entrant.hash, data)
      .then(response => {
        if(response.data.result == 'success') {
          if(sub == 'priorities') {
            this.entrant.priorities = response.data.priorities;
          };
          if(sub == 'identity_document') {
            this.entrant.identity_documents[index].id = response.data.identity_document.id;
          };
          if(sub == 'education_document') {
            this.entrant.education_documents[index].id = response.data.education_document.id;
          };
          if(sub == 'snils') {
            this.entrant.snils[index].id = response.data.snils.id;
          };
          if(sub == 'benefit_document') {
            this.entrant.benefit_documents[index].id = response.data.benefit_document.id;
          };
          if(sub == 'olympic_document') {
            this.entrant.olympic_documents[index].id = response.data.olympic_document.id;
          };
          if(sub == 'target_contract') {
            this.entrant.target_contracts[index].id = response.data.target_contract.id;
            this.entrant.stage = response.data.entrant.stage;
          };
          if(sub == 'target_offer_id') {
            this.entrant.target_offer_ids = response.data.target_offer_ids;
          };
          if(sub == 'other_document') {
            this.entrant.other_documents[index].id = response.data.other_document.id;
          };
          if(sub == 'ticket') {
            this.entrant.tickets = response.data.tickets;
          };
          if(sub == 'mark') {
            this.entrant.marks[0].marks[index].id = response.data.mark.id;
          };
          if(sub == 'competitive_group_ids') {
            this.entrant.questionnaire['priority'] = false
            this.entrant.entrant_applications = response.data.entrant_applications;
            this.entrant.competitive_groups = response.data.competitive_groups;
            this.entrant.priorities = response.data.priorities;
            this.entrant.stage = response.data.stage;
            this.entrant.status = response.data.status;
          };
          if(sub == 'institution_achievement_ids') {
            this.entrant.achievements = response.data.achievements;
            this.entrant.attachments = response.data.attachments;
          };
          if(sub == 'status') {
            this.entrant.status = response.data.status;
          };
          if(sub == 'stage') {
            this.entrant.stage = response.data.stage;
          };
          if(sub == 'contragent') {
            this.entrant.contragent.id = response.data.contragent.id;
          };
          console.log('успешно обновлено');
        }
        else
        {
          console.log('что-то пошло не так');
        }
      });
    },
    handleFiles: function(e){
      if(this.$refs.entrant && this.$refs.entrant.files.length > 0) {
        this.files = this.$refs.entrant.files;
        this.dataset = this.$refs.entrant.dataset;
      }
      if(this.$refs.recall_application && this.$refs.recall_application.files.length > 0) {
        this.files = this.$refs.recall_application.files;
        this.dataset = this.$refs.recall_application.dataset;
      }
      if(this.$refs.withdraw_application && this.$refs.withdraw_application.length > 0) {
        for(var i = 0; i < this.$refs.withdraw_application.length; i++) {
          if(this.$refs.withdraw_application[i].files.length > 0) {
          this.files = this.$refs.withdraw_application[i].files;
          this.dataset = this.$refs.withdraw_application[i].dataset;
          }
        }
      }
      if(this.$refs.contract && this.$refs.contract.length > 0) {
        for(var i = 0; i < this.$refs.contract.length; i++) {
          if(this.$refs.contract[i].files.length > 0) {
          this.files = this.$refs.contract[i].files;
          this.dataset = this.$refs.contract[i].dataset;
          }
        }
      }
      if(this.$refs.data_processing_consent && this.$refs.data_processing_consent.files.length > 0) {
        this.files = this.$refs.data_processing_consent.files;
        this.dataset = this.$refs.data_processing_consent.dataset;
      }
      if(this.$refs.medical_document && this.$refs.medical_document.files.length > 0) {
        this.files = this.$refs.medical_document.files;
        this.dataset = this.$refs.medical_document.dataset;
      }
      if(this.$refs.identity_document && this.$refs.identity_document.length > 0) {
        for(var i = 0; i < this.$refs.identity_document.length; i++) {
          if(this.$refs.identity_document[i].files.length > 0) {
          this.files = this.$refs.identity_document[i].files;
          this.dataset = this.$refs.identity_document[i].dataset;
          }
        }
      }
      if(this.$refs.education_document && this.$refs.education_document.length > 0) {
        for(var i = 0; i < this.$refs.education_document.length; i++) {
          if(this.$refs.education_document[i].files.length > 0) {
          this.files = this.$refs.education_document[i].files;
          this.dataset = this.$refs.education_document[i].dataset;
          }
        }
      }
      if(this.$refs.snils && this.$refs.snils.length > 0) {
        for(var i = 0; i < this.$refs.snils.length; i++) {
          if(this.$refs.snils[i].files.length > 0) {
          this.files = this.$refs.snils[i].files;
          this.dataset = this.$refs.snils[i].dataset;
          }
        }
      }
      if(this.$refs.benefit_document && this.$refs.benefit_document.length > 0) {
        for(var i = 0; i < this.$refs.benefit_document.length; i++) {
          if(this.$refs.benefit_document[i].files.length > 0) {
          this.files = this.$refs.benefit_document[i].files;
          this.dataset = this.$refs.benefit_document[i].dataset;
          }
        }
      }
      if(this.$refs.other_document && this.$refs.other_document.length > 0) {
        for(var i = 0; i < this.$refs.other_document.length; i++) {
          if(this.$refs.other_document[i].files.length > 0) {
          this.files = this.$refs.other_document[i].files;
          this.dataset = this.$refs.other_document[i].dataset;
          }
        }
      }
      if(this.$refs.olympic_document && this.$refs.olympic_document.length > 0) {
        for(var i = 0; i < this.$refs.olympic_document.length; i++) {
          if(this.$refs.olympic_document[i].files.length > 0) {
          this.files = this.$refs.olympic_document[i].files;
          this.dataset = this.$refs.olympic_document[i].dataset;
          }
        }
      }
      if(this.$refs.target_contract && this.$refs.target_contract.length > 0) {
        for(var i = 0; i < this.$refs.target_contract.length; i++) {
          if(this.$refs.target_contract[i].files.length > 0) {
          this.files = this.$refs.target_contract[i].files;
          this.dataset = this.$refs.target_contract[i].dataset;
          }
        }
      }
      if(this.$refs.achievement && this.$refs.achievement.length > 0) {
        for(var i = 0; i < this.$refs.achievement.length; i++) {
          if(this.$refs.achievement[i].files.length > 0) {
          this.files = this.$refs.achievement[i].files;
          this.dataset = this.$refs.achievement[i].dataset;
          }
        }
      }
      let formData = new FormData();
      for( var i = 0; i < this.files.length; i++ ){
        let file = this.files[i];
        formData.append('entrant_id', this.dataset.entrantId);
        formData.append('document_type', this.dataset.documentType);
        formData.append('document_id', this.dataset.documentId);
        formData.append('files[]', file);
      }
      axios
      .post( '/api/attachments',
        formData,
        {
          headers: {
              'Content-Type': 'multipart/form-data'
          }
        }
      )
      .then(
        response => {
        this.entrant.attachments = response.data.attachments;
        this.entrant.status = response.data.status;
        console.log(response.data.message);
        if(this.dataset.documentType == 'entrant') {
          this.$refs.entrant.value = null
        }
        if(this.dataset.documentType == 'consent_application') {
          this.$refs.consent_application.value = null
        }
        if(this.dataset.documentType == 'withdraw_application') {
          this.$refs.withdraw_application.value = null
        }
        if(this.dataset.documentType == 'contract') {
          this.$refs.contract.value = null
        }
        if(this.dataset.documentType == 'data_processing_consent') {
          this.$refs.data_processing_consent.value = null
        }
        if(this.dataset.documentType == 'medical_document') {
          this.$refs.medical_document.value = null
        }
        if(this.dataset.documentType == 'identity_document') {
          for(var i = 0; i < this.$refs.identity_document.length; i++) {
            this.$refs.identity_document[i].value = null
          }
        }
        if(this.dataset.documentType == 'snils') {
          for(var i = 0; i < this.$refs.snils.length; i++) {
            this.$refs.snils[i].value = null
          }
        }
        if(this.dataset.documentType == 'education_document') {
          for(var i = 0; i < this.$refs.education_document.length; i++) {
            this.$refs.education_document[i].value = null
          }
        }
        if(this.dataset.documentType == 'benefit_document') {
          for(var i = 0; i < this.$refs.benefit_document.length; i++) {
            this.$refs.benefit_document[i].value = null
          }
        }
        if(this.dataset.documentType == 'other_document') {
          for(var i = 0; i < this.$refs.other_document.length; i++) {
            this.$refs.other_document[i].value = null
          }
        }
        if(this.dataset.documentType == 'olympic_document') {
          for(var i = 0; i < this.$refs.olympic_document.length; i++) {
            this.$refs.olympic_document[i].value = null
          }
        }
        if(this.dataset.documentType == 'target_contract') {
          for(var i = 0; i < this.$refs.target_contract.length; i++) {
            this.$refs.target_contract[i].value = null
          }
        }
        if(this.dataset.documentType == 'achievement') {
          for(var i = 0; i < this.$refs.achievement.length; i++) {
            this.$refs.achievement[i].value = null
          }
        }
        if(this.dataset.documentType == 'recall_application') {
          for(var i = 0; i < this.$refs.recall_application.length; i++) {
            this.$refs.recall_application[i].value = null
          }
        }
        this.files = '';
        this.dataset = '';
      })
    },
    checkForm: function(tab) {
      this.errors = [];
      if(tab == 'benefits' || tab == 'target' || tab == 'competitions' || tab == 'others' || tab == 'applications'){
        if(this.entrant.personal.last_name == '') this.errors.push({element: 'last_name', message: 'Необходимо указать фамилию', level: 'red'});
        if(this.entrant.personal.first_name == '') this.errors.push({element: 'first_name', message: 'Необходимо указать имя', level: 'red'});
        if(this.entrant.personal.birth_date == '') this.errors.push({element: 'birth_date', message: 'Необходимо указать дату рождения', level: 'red'});
        if(this.entrant.personal.gender == null) this.errors.push({element: 'gender', message: 'Необходимо указать пол', level: 'red'});
        if(this.entrant.contact_information.phone == '') this.errors.push({element: 'phone', message: 'Необходимо контактный телефон', level: 'red'});
        if(this.entrant.identity_documents.find(function(element) {
          if(element.document_category == ''){
            entrants.errors.push({element: 'identity_document_category', message: 'Необходимо выбрать тип документа, удостоверяющего личность', level: 'red'});
          };
          if(element.document_category == 'Паспорт гражданина Российской Федерации' && element.serie.length != 4){
            entrants.errors.push({element: 'identity_document_serie', message: 'Выбран тип документа Российский паспорт, но серия указана неправильно', level: 'red'});
          };
          if(element.number == ''){
            entrants.errors.push({element: 'identity_document_number', message: 'Необходимо указать номер документа, удостоверяющего личность', level: 'red'});
          };
          if(element.document_category == 'Паспорт гражданина Российской Федерации' && element.number.length != 6){
            entrants.errors.push({element: 'identity_document_number', message: 'Выбран тип документа Российский паспорт, но номер указан неправильно', level: 'red'});
          };
          if(element.date == ''){
            entrants.errors.push({element: 'identity_document_date', message: 'Необходимо указать дату выдачи документа, удостоверяющего личность', level: 'red'});
          };
          if(!entrants.findAttachment(element.id, 'identity_document', false) && !(entrants.entrant.source === 'через ЕПГУ')) entrants.errors.push({element: 'identity_document_attachment', message: 'Необходимо прикрепить копию документа, удостоверяющего личность', level: 'red'});
        }));
        if(this.entrant.snils.find(function(element){
          if(element.number == '' && entrants.entrant.nationality == 'РОССИЯ') {
            entrants.errors.push({element: 'snils_number', message: 'Необходимо указать номер СНИЛС', level: 'red'})
          }
        }));
        if(this.entrant.education_documents.find(function(element) {
          if(element.document_category == ''){
            entrants.errors.push({element: 'education_document_category', message: 'Необходимо выбрать тип документа об образовании', level: 'red'});
          };
          if(element.number == ''){
            entrants.errors.push({element: 'education_document_number', message: 'Необходимо указать номер документа об образовании', level: 'red'});
          };
          if(element.date == ''){
            entrants.errors.push({element: 'education_document_date', message: 'Необходимо указать дату выдачи документа об образовании', level: 'red'});
          };
          if(element.issuer == ''){
            entrants.errors.push({element: 'education_document_issuer', message: 'Необходимо указать кем выдан документ об образовании', level: 'red'});
          };
          if(!entrants.findAttachment(element.id, 'education_document', false) && !(entrants.entrant.source === 'через ЕПГУ')) entrants.errors.push({element: 'education_document_attachment', message: 'Необходимо прикрепить документ об образовании', level: 'red'});
        }));
      }
      if(tab == 'target' || tab == 'others' || tab == 'applications'){
        if(this.entrant.benefit_documents.find(function(element) {
          if(element.document_category == '' && (entrants.entrant.questionnaire['benefit'] || entrants.entrant.questionnaire['special'])) {
            entrants.errors.push({element: 'benefit_document_category', message: 'Необходимо выбрать тип документа, подтверждающего льготу', level: 'red'});
          };
          if(element.number == '' && (entrants.entrant.questionnaire['benefit'] || entrants.entrant.questionnaire['special'])) {
            entrants.errors.push({element: 'benefit_document_number', message: 'Не указан номер документа, подтверждающего льготу. Если номер отсутствует, напишите "нет"', level: 'red'});
          };
          if(element.date == '' && (entrants.entrant.questionnaire['benefit'] || entrants.entrant.questionnaire['special'])) {
            entrants.errors.push({element: 'benefit_document_date', message: 'Необходимо указать дату выдачи документа, подтверждающего льготу', level: 'red'});
          };
          if(element.issuer == '' && (entrants.entrant.questionnaire['benefit'] || entrants.entrant.questionnaire['special'])) {
            entrants.errors.push({element: 'benefit_document_issuer', message: 'Необходимо указать кем выдан документ, подтверждающий льготу', level: 'red'});
          };
          if(!entrants.findAttachment(element.id, 'benefit_document', false) && (entrants.entrant.questionnaire['benefit'] || entrants.entrant.questionnaire['special']) && !(entrants.entrant.source === 'через ЕПГУ')) entrants.errors.push({element: 'benefit_document', message: 'Необходимо прикрепить копию документа, подтверждающего льготу', level: 'red'});
        }));
        if(this.entrant.olympic_documents.find(function(element) {
          if(element.document_category == '' && entrants.entrant.questionnaire['olympionic']){
            entrants.errors.push({element: 'olympic_document_category', message: 'Не указан тип диплома олимпиады', level: 'red'});
          };
          if(element.number == '' && entrants.entrant.questionnaire['olympionic']){
            entrants.errors.push({element: 'olympic_document_number', message: 'Не указан код подтверждения диплома олимпиады. Если код отсутствует, напишите "нет', level: 'red'});
          };
          if(element.profile == '' && entrants.entrant.questionnaire['olympionic']){
            entrants.errors.push({element: 'olympic_profile', message: 'Не выбран профиль олимпиады', level: 'red'});
          };
          if(element.date == '' && entrants.entrant.questionnaire['olympionic']){
            entrants.errors.push({element: 'olympic_document_date', message: 'Необходимо указать дату проведения олимпиады', level: 'red'});
          };
          if(element.class_number == '' && entrants.entrant.questionnaire['olympionic']){
            entrants.errors.push({element: 'class_number', message: 'Необходимо указать в каком классе получен диплом олимпиады', level: 'red'});
          };
          if(!entrants.findAttachment(element.id, 'olympic_document', false) && entrants.entrant.questionnaire['olympionic'] && !(entrants.entrant.source === 'через ЕПГУ')) entrants.errors.push({element: 'olympic_document', message: 'Необходимо прикрепить копию диплома олимпиады', level: 'red'});
        }));
      }
      if(tab == 'competitions') {
        if(this.entrant.target_contracts.find(function(element) {
          if(element.competitive_group_id && element.date == null) entrants.errors.push({element: 'target_contract_date', message: 'Необходимо указать дату заключения договора', level: 'red'});
          if(!entrants.findAttachment(element.id, 'target_contract', false) && element.competitive_group_id && !(entrants.entrant.source === 'через ЕПГУ')) entrants.errors.push({element: 'target_contract', message: 'Необходимо прикрепить копию целевого договора', level: 'red'});
        }));
      }
      if(tab == 'others' || tab == 'applications'){
        if(this.entrant.competitive_group_ids.length == 0) this.errors.push({element: 'competitive_group_ids', message: 'Необходимо отметить участие хотя бы в одном конкурсе', level: 'red'});
        if(!entrants.entrant.questionnaire['priority']) entrants.errors.push({element: 'priority', message: 'Необходимо подтвердить расстановку приоритетов конкурсов.', level: 'red'});
      }
      if(tab == 'applications'){
        if(!this.entrant.contact_information.address) this.errors.push({element: 'address', message: 'Необходимо указать адрес', level: 'red'});
        if(this.entrant.questionnaire['special_entrant'] && !this.entrant.questionnaire['benefit']) this.errors.push({element: 'special_entrant', message: 'Указана необходимость создания специальных условий для сдачи вступительных испытаний, но не указано наличие льготы на вкладке Льготы', level: 'red'});
        if(this.entrant.questionnaire['special_entrant'] && this.entrant.special_conditions == null) this.errors.push({element: 'special_conditions', message: 'Указана необходимость создания специальных условий для сдачи вступительных испытаний, но не указан перечень условий', level: 'red'});
      }
    },
    addIdentityDocument: function() {
      this.entrant.identity_documents.push({
        id: null,
        document_type: 'identity_document',
        document_category: '',
        serie: '',
        number: '',
        date: '',
        issuer: '',
        last_name: '',
        first_name: '',
        middle_name: ''
      });
    },
    deleteIdentityDocument: function() {
      if(this.entrant.identity_documents.length > 1) this.entrant.identity_documents.splice(-1, 1);
    },
    addTargetContract: function() {
      this.entrant.target_contracts.push({
        id: null,
        document_type: 'target_contract',
        document_category: 'Договор о целевом обучении',
        competitive_group_id: '',
        date: '',
        number: '',
        employer: '',
        employer_ogrn: '',
        employer_kpp: '',
        employer_region: ''
      });
    },
    deleteTargetContract: function() {
      if(this.entrant.target_contracts.length > 1) this.entrant.target_contracts.splice(-1, 1);
    },
    addBenefitDocument: function() {
      this.entrant.benefit_documents.push({
        id: null,
        document_type: 'benefit_document',
        document_category: '',
        serie: '',
        number: '',
        date: '',
        issuer: '',
        original: ''
      });
    },
    deleteBenefitDocument: function() {
      if(this.entrant.benefit_documents.length > 1) this.entrant.benefit_documents.splice(-1, 1);
    },
    addOlympicDocument: function() {
      this.entrant.olympic_documents.push({
        id: null,
        document_type: 'olympic_document',
        document_category: '',
        serie: '',
        number: '',
        date: '',
        issuer: '',
        original: ''
      });
    },
    deleteOlympicDocument: function() {
      if(this.entrant.olympic_documents.length > 1) this.entrant.olympic_documents.splice(-1, 1);
    },
    addOtherDocument: function() {
      this.entrant.other_documents.push({
        id: null,
        document_type: 'other_document',
        document_category: '',
        serie: '',
        number: '',
        date: '',
        issuer: '',
        original: ''
      });
    },
    deleteOtherDocument: function() {
      if(this.entrant.other_documents.length > 1) this.entrant.other_documents.splice(-1, 1);
    },
    addTicket: function() {
      this.entrant.tickets.push({
        id: null,
        entrant_id: null,
        parent_ticket: null,
        message: '',
        solved: false,
        created_at: null,
        chidlren: []
      });
    },
    deleteTicket: function() {
      if(this.entrant.tickets.length > 1) this.entrant.tickets.splice(-1, 1);
    },
    findErrorMessage: function(field_name) {
      var message = '';
      this.errors.find(function(element) {
        if(field_name == element.element) {
          message = element.message;
        }
      });
      return message;
    },
    setCurrentTab: function(tab) {
      window.scrollTo({ top: 0, behavior: 'smooth' });
      this.checkForm(tab);
      if(this.errors.length == 0){
        this.api.current_tab = tab;
        if(this.api.current_tab == 'applications' && this.entrant.stage < 4){
          this.generateTemplates();
        }
        if(this.api.current_tab == 'start' && this.entrant.stage == 0){
          this.sendData('stage', this.entrant.stage);
        }
      };
    }
  },
  created: function() {
  axios
    .get('/api/entrants/' + this.api.hash)
    .then(
      response => {
        this.entrant = response.data.entrant;
        if(this.entrant.stage != 0) this.api.current_tab = 'start';
        if(this.entrant.identity_documents.length == 0) this.entrant.identity_documents.push({
          id: null,
          document_type: 'identity_document',
          document_category: '',
          serie: '',
          number: '',
          date: '',
          issuer: '',
          last_name: '',
          first_name: '',
          middle_name: '',
          division_code: '',
          birth_place: ''
        });
        if(this.entrant.education_documents.length == 0 && this.entrant.campaign.campaign_type == 'Прием на обучение по ОП бакалавриата/специалитета') this.entrant.education_documents.push({
          id: null,
          document_type: 'education_document',
          document_category: '',
          number: '',
          date: '',
          issuer: '',
          original: '',
        });
        if(this.entrant.education_documents.length == 0 && this.entrant.campaign.campaign_type == 'Прием на подготовку кадров высшей квалификации') this.entrant.education_documents.push({
          id: null,
          document_type: 'education_document',
          document_category: 'Диплом о высшем профессиональном образовании',
          number: '',
          date: '',
          issuer: '',
          original: '',
          speciality: '',
        });
        if(this.entrant.snils.length == 0) this.entrant.snils.push({
          id: null,
          document_type: 'snils',
          number: '',
        });
        if(this.entrant.marks.length == 0 && this.entrant.campaign.campaign_type == 'Прием на подготовку кадров высшей квалификации') this.entrant.marks.push({
          subject: 'Здравоохранение',
          marks: [
          {
            id: null,
            value: null,
            subject: 'Здравоохранение',
            test_type: '',
            checked: false,
            year: null,
            organization_uid: ''
          }],
        });
        if(this.entrant.achievements.length == 0) this.entrant.achievements.push({
          id: null,
          name: '',
          value: '',
          status: null
        });
        if(this.entrant.olympic_documents.length == 0) this.entrant.olympic_documents.push({
          id: null,
          document_type: 'olympic_document',
          document_category: '',
          number: '',
          date: '',
          class_number: '',
          profile: '',
          original: ''
        });
        if(this.entrant.benefit_documents.length == 0) this.entrant.benefit_documents.push({
          id: null,
          document_type: 'benefit_document',
          document_category: '',
          serie: '',
          number: '',
          date: '',
          issuer: '',
          original: ''
        });
        if(this.entrant.other_documents.length == 0) this.entrant.other_documents.push({
          id: null,
          document_type: 'other_document',
          document_category: '',
          serie: '',
          number: '',
          date: '',
          issuer: '',
          original: ''
        });
        if(this.entrant.target_contracts.length == 0) this.entrant.target_contracts.push({
          id: null,
          document_type: 'target_contract',
          competitive_group_id: '',
          date: '',
          number: '',
          employer: '',
          employer_ogrn: '',
          employer_kpp: '',
          employer_region: ''
        });
        if(!this.entrant.contragent) this.entrant.contragent = {
          id: null,
          last_name: '',
          first_name: '',
          middle_name: '',
          birth_date: '',
          identity_document_serie: '',
          identity_document_number: '',
          identity_document_date: '',
          identity_document_issuer: '',
          identity_document_data: '',
          email: '',
          phone: '',
          address: ''
        };
        axios
          .get('/api/campaigns/' + this.entrant.campaign.id)
          .then(response => (this.api.dictionaries.campaign = response.data.campaign));
      });
  axios
    .get('/api/dictionaries/10')
    .then(response => (this.api.dictionaries.identity_document_categories = response.data.dictionary.items));
  axios
    .get('/api/dictionaries/29')
    .then(response => (this.api.dictionaries.regions = response.data.dictionary.items));
  },
})
