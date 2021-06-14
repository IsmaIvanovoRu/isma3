var entrants = new Vue({
  el: '#entrant_application',
  data: {
    api: {
      hash: window.document.location.pathname.split('/')[2],
      current_tab: 'common',
      dictionaries: {
        campaign: null,
        countries: [],
        campaigns: [],
        identityDocumentTypes: [],
        specialities: [],
        benefitDocumentTypes: [
          {
            id: 11,
            name: "Справка об установлении инвалидности"
          },
          {
            id: 30,
            name: "Документ, подтверждающий принадлежность к детям-сиротам и детям, оставшимся без попечения родителей"
          },
          {
            id: 31,
            name: "Документ, подтверждающий принадлежность к ветеранам боевых действий"
          },
          {
            id: 32,
            name: "Документ, подтверждающий наличие только одного родителя - инвалида I группы и принадлежность к числу малоимущих семей"
          },
          {
            id: 33,
            name: "Документ, подтверждающий принадлежность родителей и опекунов к погибшим в связи с исполнением служебных обязанностей"
          },
          {
            id: 34,
            name: "Документ, подтверждающий принадлежность к сотрудникам государственных органов Российской Федерации"
          },
          {
            id: 35,
            name: "Документ, подтверждающий участие в работах на радиационных объектах или воздействие радиации"
          }
        ],
        olympicDocumentTypes: [
          {
            id: 9,
            name: "Диплом победителя/призера олимпиады школьников"
          },
          {
            id: 10,
            name: "Диплом победителя/призера всероссийской олимпиады школьников"
          }
        ],
        educationDocumentTypes: [
          {
            id: 'SchoolCertificateDocument',
            name: "Аттестат о среднем (полном) общем образовании"
          },
          {
            id: 'MiddleEduDiplomaDocument',
            name: "Диплом о среднем профессиональном образовании"
          },
          {
            id: 'HighEduDiplomaDocument',
            name: "Диплом о высшем профессиональном образовании"
          }
        ],
        otherDocumentTypes: [
          'Свидетельство об аккредитации специалиста',
          'Выписка из итогового протокола заседания аккредитационной комиссии',
          'Сертификат специалиста',
          'Военный билет',
          'Документ о смене фамилии',
          'Иной документ'
        ],
        educationSpecialityCodes: [
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
    entrantApplication: {
      applicationNumber: '',
      campaignId: '',
      nationalityTypeId: false,
      personal: {
        entrantLastName: '',
        entrantFirstName: '',
        entrantMiddleName: '',
        genderId: '',
        birthDate: '',
      },
      contactInformation: {
        address: '',
        zipCode: '',
        email: '',
        phone: ''
      },
      benefit: false,
      olympionic: false,
      budgetAgr: null,
      paidAgr: null,
      statusId: null,
      comment: '',
      status: '',
      request: '',
      enrolled: null,
      enrolledDate: '',
      needHostel: false,
      specialEntrant: false,
      specialConditions: '',
      hash: '',
      snils: '',
      snilsAbsent: false,
      identityDocuments: [
        {
          id: null,
          identityDocumentType: '',
          identityDocumentSeries: '',
          identityDocumentNumber: '',
          identityDocumentDate: '',
          identityDocumentIssuer: '',
          status: null,
          identityDocumentData: '',
          altEntrantLastName: '',
          altEntrantFirstName: '',
          altEntrantMiddleName: ''
        }
      ],
      educationDocument: {
        id: null,
        educationDocumentType: '',
        educationDocumentNumber: '',
        educationDocumentDate: '',
        educationDocumentIssuer: '',
        originalReceivedDate: '',
        educationSpecialityCode: '',
        status: null,
        isOriginal: false,
        },
      marks: [
        {
          id: null,
          value: null,
          subjectId: null,
          subject: '',
          form: '',
          checked: false,
          organizationUid: ''
        }
      ],
      sum: null,
      achievementsSum: null,
      fullSum: null,
      achievements: [
        {
          id: null,
          name: '',
          value: '',
          status: null
        }
      ],
      olympicDocuments: [
        {
          id: null,
          benefitDocumentTypeId: null,
          olympicId: null,
          diplomaTypeId: null,
          olympicProfileId: null,
          classNumber: null,
          olympicDocumentSeries: '',
          olympicDocumentNumber: '',
          olympicDocumentDate: '',
          olympicSubjectId: null,
          ege_subjectId: null,
          status: null,
          olympicDocumentTypeId: null,
        }
      ],
      benefitDocuments: [
        {
          id: null,
          benefitDocumentTypeId: null,
          benefitDocumentSeries: '',
          benefitDocumentNumber: '',
          benefitDocumentDate: '',
          benefitDocumentOrganization: '',
          benefitTypeId: null,
          status: null
        }
      ],
      otherDocuments: [
        {
          id: null,
          otherDocumentSeries: '',
          otherDocumentNumber: '',
          otherDocumentIssuer: '',
          name: ''
        }
      ],
      competitiveGroups: [
        {
          id: null,
          name: '',
          educationLevelId: null,
          educationSourceId: null,
          educationFormId: null,
          directionId: null
        }
      ],
      targetContracts: [
        {
          id: null,
          competitiveGroupId: null,
          competitiveGroupName: '',
          targetOrganizationId: null,
          targetOrganizationName: '',
          status: null
        }
      ],
      contracts: [
        {
          competitiveGroupId:  null,
          competitiveGroupName: '',
          status: null
        }
      ],
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
      ],
    }
  },
  computed: {
    checkEntrantLastName: function() {
      if(this.entrantApplication.personal.entrantLastName.charAt(0).toUpperCase() + this.entrantApplication.personal.entrantLastName.slice(1).toLowerCase() != this.entrantApplication.personal.entrantLastName) return 'Обычно фамилия начинается с заглавной буквы, за которой следуют строчные';
    },
    checkEntrantFirstName: function() {
      if(this.entrantApplication.personal.entrantFirstName.charAt(0).toUpperCase() + this.entrantApplication.personal.entrantFirstName.slice(1).toLowerCase() != this.entrantApplication.personal.entrantFirstName) return 'Обычно имя начинается с заглавной буквы, за которой следуют строчные';
    },
    checkEntrantMiddleName: function() {
      if(this.entrantApplication.personal.entrantMiddleName.charAt(0).toUpperCase() + this.entrantApplication.personal.entrantMiddleName.slice(1).toLowerCase() != this.entrantApplication.personal.entrantMiddleName) return 'Обычно отчество начинается с заглавной буквы, за которой следуют строчные';
    },
    checkBirthDate: function() {
      var numbers = this.entrantApplication.personal.birthDate.split('-');
      var birthYear = Number(numbers[0]);
      var birthMonth = Number(numbers[1]);
      var birthDay = Number(numbers[2]);
      var message = [];
      var year = (new Date()).getFullYear();
      if(birthYear + birthMonth + birthDay) {
        if(!(Number(numbers[0]) > 0 && Number(numbers[0]) < Number(year))) message.push('Неверный год');
        if(!(Number(numbers[1]) > 0 && Number(numbers[1]) < 13)) message.push('Неверный месяц');
        if(!(Number(numbers[2]) > 0 && Number(numbers[2]) < 32)) message.push('Неверный день');
        return message.join(', ')
      }
    },
    checkIdentityDocumentSerie: function() {
      message = '';
      if(this.entrantApplication.identityDocuments.find(function(element) {
        if(element.documentSerie == '') message = 'Необходимо указать серию документа, удостоверяющего личность';
      }));
      return message;
    },
    checkIdentityDocumentNumber: function() {
      message = '';
      if(this.entrantApplication.identityDocuments.find(function(element) {
        if(element.documentNumber == '') message = 'Необходимо указать номер документа, удостоверяющего личность';
      }));
      return message;
    },
    checkIdentityDocumentDate: function() {
      if(this.entrantApplication.identityDocuments.find(function(element) {
        var numbers = element.identityDocumentData.split('-');
        var birthYear = Number(numbers[0]);
        var birthMonth = Number(numbers[1]);
        var birthDay = Number(numbers[2]);
        var message = [];
        var year = (new Date()).getFullYear();
        if(birthYear + birthMonth + birthDay) {
          if(!(Number(numbers[0]) > 0 && Number(numbers[0]) < Number(year))) message.push('Неверный год');
          if(!(Number(numbers[1]) > 0 && Number(numbers[1]) < 13)) message.push('Неверный месяц');
          if(!(Number(numbers[2]) > 0 && Number(numbers[2]) < 32)) message.push('Неверный день');
        };
        return message.join(', ')
      }));
    },
    checkEducationDocumentDate: function() {
      var numbers = this.entrantApplication.educationDocument.educationDocumentDate.split('-');
      var birthYear = Number(numbers[0]);
      var birthMonth = Number(numbers[1]);
      var birthDay = Number(numbers[2]);
      var message = [];
      var year = (new Date()).getFullYear() + 1;
      if(birthYear + birthMonth + birthDay) {
        if(!(Number(numbers[0]) > 0 && Number(numbers[0]) < Number(year))) message.push('Неверный год');
        if(!(Number(numbers[1]) > 0 && Number(numbers[1]) < 13)) message.push('Неверный месяц');
        if(!(Number(numbers[2]) > 0 && Number(numbers[2]) < 32)) message.push('Неверный день');
        return message.join(', ')
      }
    },
    checkContactInformationZipCode: function() {
      if(this.entrantApplication.contactInformation.zipCode == '') return 'Необходимо указать почтовый индекс';
    },
    checkContactInformationAddress: function() {
      if(this.entrantApplication.contactInformation.address == '') return 'Необходимо указать адрес проживания';
    },
    checkContactInformationEmail: function() {
      if(this.entrantApplication.contactInformation.email == '') return 'Необходимо указать адрес электронной почты';
    },
    checkContactInformationPhone: function() {
      if(this.entrantApplication.contactInformation.phone == '') return 'Необходимо указать контактный телефон';
    },
  },
  methods: {
    fillMarks: function(entranceTestItems) {
      var marks = [];
      entranceTestItems.forEach(function(element){
        marks.push({entranceSubjectId: element.subject_id, subjectName: element.subject_name, minScore: element.min_score, value: null, form: '', year: null, organizationUid: ''});
      });
      return this.marks = marks;
    },
    findCampaign: function(campaignId) {
      var findCampaign = null;
      this.api.dictionaries.campaigns.find(function(element) {
        if(campaignId == element.id){
          findCampaign = element;
        };
      });
      return findCampaign;
    },
    checkForm: function(e) {
      this.errors = [];
      if(!this.entrantApplication.citizenship) this.errors.push({element: 'citizenship', message: 'Необходимо указать гражданство', level: 'red'});
      if(this.entrantApplication.campaignId == '') this.errors.push({element: 'campaignId', message: 'Необходимо выбрать приемную кампанию', level: 'red'});
      if(this.entrantApplication.personal.checkLastName) this.errors.push({element: 'entrantLastName', message: this.checkLastName, level: 'yellow'});
      if(this.entrantApplication.personal.checkFirstName) this.errors.push({element: 'entrantFirstName', message: this.checkFirstName, level: 'yellow'});
      if(this.entrantApplication.personal.checkMiddleName) this.errors.push({element: 'entrantMiddleName', message: this.checkMiddleName, level: 'yellow'});
      if(this.entrantApplication.personal.birthDate == '') this.errors.push({element: 'birthDate', message: 'Необходимо указать дату рождения', level: 'red'});
      if(this.entrantApplication.personal.genderId == '') this.errors.push({element: 'gender_id', message: 'Необходимо указать пол', level: 'red'});
      if(this.entrantApplication.identityDocuments.find(function(element) {
        if(element.documentType == ''){
          entrants.errors.push({element: 'identityDocumentType', message: 'Необходимо выбрать тип документа, удостоверяющего личность', level: 'red'});
        };
      }));
      if(this.checkIdentityDocumentNumber) this.errors.push({element: 'identityDocumentNumber', message: this.checkIdentityDocumentNumber, level: 'red'});
      if(this.entrantApplication.identityDocuments.find(function(element) {
        if(element.documentDate == ''){
          entrants.errors.push({element: 'identityDocumentDate', message: 'Необходимо указать дату выдачи документа, удостоверяющего личность', level: 'red'});
        };
      }));
//       if(this.educationDocument.documentType == '') this.errors.push({element: 'education_document_type_id', message: 'Необходимо выбрать тип документа об образовании', level: 'red'});
      if(this.entrantApplication.educationDocument.documentNumber == '') this.errors.push({element: 'education_document_number', message: 'Необходимо указать номер документа об образовании', level: 'red'});
      if(this.entrantApplication.marks.find(function(element) {
        if(element.form == ''){
          entrants.errors.push({element: 'mark', message: 'Необходимо указать указать форму вступительного испытания', level: 'red'});
        };
      }));
//       if(this.competitions.find(function(element) {
//         if(element.id == ''){
//           entrants.errors.push({element: 'competition', message: 'Необходимо выбрать конкурсы для участия', level: 'red'});
//         };
//       }));
      if(this.checkContactInformationAddress) this.errors.push({element: 'address', message: this.checkContactInformationAddress, level: 'yellow'});
      if(this.checkContactInformationEmail) this.errors.push({element: 'email', message: this.checkContactInformationEmail, level: 'red'});
      if(this.errors.length == 0) return true;
      e.preventDefault();
    },
    addIdentityDocument: function() {
      this.entrantApplication.identityDocuments.push({
        id: null,
        identityDocumentType: '',
        identityDocumentSeries: '',
        identityDocumentNumber: '',
        identityDocumentDate: '',
        identityDocumentIssuer: '',
        status: null,
        identityDocumentData: '',
        altEntrantLastName: '',
        altEntrantFirstName: '',
        altEntrantMiddleName: ''
      });
    },
    deleteIdentityDocument: function() {
      if(this.entrantApplication.identityDocuments.length > 1) this.entrantApplication.identityDocuments.splice(-1, 1);
    },
    addTargetContract: function() {
      this.entrantApplication.targetContracts.push({
        id: null,
        competitiveGroupId: null,
        competitiveGroupName: '',
        targetOrganizationId: null,
        targetOrganizationName: '',
        status: null
      });
    },
    deleteTargetContract: function() {
      if(this.entrantApplication.targetContracts.length > 1) this.entrantApplication.targetContracts.splice(-1, 1);
    },
    addBenefitDocument: function() {
      this.entrantApplication.benefitDocuments.push({documentType: '', documentSerie: '', documentNumber: '', documentDate: '', documentIssuer: ''});
    },
    deleteBenefitDocument: function() {
      if(this.entrantApplication.benefitDocuments.length > 1) this.entrantApplication.benefitDocuments.splice(-1, 1);
    },
    addOlympicDocument: function() {
      this.entrantApplication.olympicDocuments.push({documentType: '', documentSerie: '', documentNumber: '', documentDate: '', documentIssuer: ''});
    },
    deleteOlympicDocument: function() {
      if(this.entrantApplication.olympicDocuments.length > 1) this.entrantApplication.olympicDocuments.splice(-1, 1);
    },
    addOtherDocument: function() {
      this.entrantApplication.otherDocuments.push({documentName: '', documentSerie: '', documentNumber: '', documentDate: '', documentIssuer: ''});
    },
    deleteOtherDocument: function() {
      if(this.entrantApplication.otherDocuments.length > 1) this.entrantApplication.otherDocuments.splice(-1, 1);
    },
    specialityName: function(direction_id) {
      var name = '';
      this.api.specialities_dictionary.find(function(element) {
        if(element.id == direction_id) {
          name = element.name;
        }
      });
      return name;
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
    setCurrentTab: function(tab) {
      this.api.current_tab = tab
    }
  },
  mounted: function() {
    axios
      .get('/api/campaigns')
      .then(response => (this.api.dictionaries.campaigns = response.data.campaigns));
    axios
      .get('/api/dictionaries/10')
      .then(response => (this.api.dictionaries.specialitiesDictionary = response.data.dictionary.items));
    axios
      .get('/api/dictionaries/21')
      .then(response => (this.api.dictionaries.countries = response.data.dictionary.items));
    axios
      .get('/api/dictionaries/22')
      .then(response => (this.api.dictionaries.identityDocumentTypes = response.data.dictionary.items));
    axios
      .get('/api/entrant_applications/' + this.api.hash)
      .then(
        response => {
          this.entrantApplication = response.data.entrantApplication;
          if(this.entrantApplication.campaignId) this.api.campaign = this.findCampaign(this.entrantApplication.campaignId);
          if(this.entrantApplication.identityDocuments.length == 0) this.entrantApplication.identityDocuments.push({
            id: null,
            identityDocumentType: '',
            identityDocumentSeries: '',
            identityDocumentNumber: '',
            identityDocumentDate: '',
            identityDocumentIssuer: '',
            status: null,
            identityDocumentData: '',
            altEntrantLastName: '',
            altEntrantFirstName: '',
            altEntrantMiddleName: ''
          });
          if(!this.entrantApplication.educationDocument) this.entrantApplication.educationDocument = {
            id: null,
            educationDocumentType: '',
            educationDocumentNumber: '',
            educationDocumentDate: '',
            educationDocumentIssuer: '',
            originalReceivedDate: '',
            educationSpecialityCode: '',
            status: null,
            isOriginal: false,
          };
          if(this.entrantApplication.marks.length == 0) this.entrantApplication.marks.push({
            id: null,
            value: null,
            subject_id: null,
            subject: '',
            form: '',
            checked: false,
            organizationUid: ''
          });
          if(this.entrantApplication.achievements.length == 0) this.entrantApplication.achievements.push({
            id: null,
            name: '',
            value: '',
            status: null
          });
          if(this.entrantApplication.olympicDocuments.length == 0) this.entrantApplication.olympicDocuments.push({
            id: null,
            benefitDocumentTypeId: null,
            olympicId: null,
            diplomaTypeId: null,
            olympicProfileId: null,
            classNumber: null,
            olympicDocumentSeries: '',
            olympicDocumentNumber: '',
            olympicDocumentDate: '',
            olympicSubjectId: null,
            ege_subjectId: null,
            status: null,
            olympicDocumentTypeId: null,
          });
          if(this.entrantApplication.benefitDocuments.length == 0) this.entrantApplication.benefitDocuments.push({
            id: null,
            benefitDocumentTypeId: null,
            benefitDocumentSeries: '',
            benefitDocumentNumber: '',
            benefitDocumentDate: '',
            benefitDocumentOrganization: '',
            benefitTypeId: null,
            status: null
          });
          if(this.entrantApplication.otherDocuments.length == 0) this.entrantApplication.otherDocuments.push({
            id: null,
            otherDocumentSeries: '',
            otherDocumentNumber: '',
            otherDocumentIssuer: '',
            name: ''
          });
          if(this.entrantApplication.targetContracts.length == 0) this.entrantApplication.targetContracts.push({
            id: null,
            competitiveGroupId: null,
            competitiveGroupName: '',
            targetOrganizationId: null,
            targetOrganizationName: '',
            status: null
          });
          if(this.entrantApplication.contracts.length == 0) this.entrantApplication.contracts.push({
            competitiveGroupId:  null,
            competitiveGroupName: '',
            status: null
          });
        });
  }
})
