var entrants = new Vue({
  el: '#entrant_application',
  data: {
    api: {
      host: window.document.location.hostname,
      countries: null,
      campaigns: null,
      identity_document_types: null,
      specialities_dictionary: null,
      benefit_document_types: [
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
      olympic_document_types: [
        {
          id: 9, 
          name: "Диплом победителя/призера олимпиады школьников"
        },
        {
          id: 10,
          name: "Диплом победителя/призера всероссийской олимпиады школьников"
        }
      ],
      education_document_types: [
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
      ]
    },
    errors: [],
    campaign_id: '',
    citizenship: false,
    personal: {
      lastName: '',
      firstName: '',
      middleName: '',
      gender_id: '',
      birthDate: ''
    },
    identityDocuments: [
      {
        documentType: '',
        documentSerie: '',
        documentNumber: '',
        documentDate: '',
        documentIssuer: '',
      }
    ],
    educationDocument: {
    documentType: '',
    documentSerie: '',
    documentNumber: '',
    documentDate: '',
    documentIssuer: '',
    isOriginal: false
    },
  contactInformation: {
    address: '',
    zipCode: '',
    email: '',
    phone: ''
  },
  competitionGroups: [],
  benefitDocuments: [
    {
    documentType: '',
    documentSerie: '',
    documentNumber: '',
    documentDate: '',
    documentIssuer: ''
    }
  ],
  olympicDocuments: [
    {
    documentType: '',
    documentSerie: '',
    documentNumber: '',
    documentDate: '',
    classNumber: '',
    olympicResult: ''
    }
  ],
  specialities: [],
  competitions: [
    {
      id: '',
      targetOrganizationName: '',
    },
  ],
  marks: [],
  institutionAchievements: [
      {
        institution_achievement_id: ''
      }
    ],
  needHostel: false,
  specialEntrant: false,
  specialConditions: '',
  originalReceiving: false
  },
  computed: {
    checkLastName: function() {
      if(this.personal.lastName.charAt(0).toUpperCase() + this.personal.lastName.slice(1).toLowerCase() != this.personal.lastName) return 'Обычно фамилия начинается с заглавной буквы, за которой следуют строчные';
    },
    checkFirstName: function() {
      if(this.personal.firstName.charAt(0).toUpperCase() + this.personal.firstName.slice(1).toLowerCase() != this.personal.firstName) return 'Обычно имя начинается с заглавной буквы, за которой следуют строчные';
    },
    checkMiddleName: function() {
      if(this.personal.middleName.charAt(0).toUpperCase() + this.personal.middleName.slice(1).toLowerCase() != this.personal.middleName) return 'Обычно отчество начинается с заглавной буквы, за которой следуют строчные';
    },
    checkBirthDate: function() {
      var numbers = this.personal.birthDate.split('-');
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
      if(this.identityDocuments.find(function(element) {
        if(element.documentSerie == '') message = 'Необходимо указать серию документа, удостоверяющего личность';
      }));
      return message;
    },
    checkIdentityDocumentNumber: function() {
      message = '';
      if(this.identityDocuments.find(function(element) {
        if(element.documentNumber == '') message = 'Необходимо указать номер документа, удостоверяющего личность';
      }));
      return message;
    },
    checkIdentityDocumentDate: function() {
      if(this.identityDocuments.find(function(element) {
        var numbers = element.documentDate.split('-');
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
      var numbers = this.educationDocument.documentDate.split('-');
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
      if(this.contactInformation.zipCode == '') return 'Необходимо указать почтовый индекс';
    },
    checkContactInformationAddress: function() {
      if(this.contactInformation.address == '') return 'Необходимо указать адрес проживания';
    },
    checkContactInformationEmail: function() {
      if(this.contactInformation.email == '') return 'Необходимо указать адрес электронной почты';
    },
    checkContactInformationPhone: function() {
      if(this.contactInformation.phone == '') return 'Необходимо указать контактный телефон';
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
      if(!this.citizenship) this.errors.push({element: 'citizenship', message: 'Необходимо указать гражданство', level: 'red'});
      if(this.campaign_id == '') this.errors.push({element: 'campaign_id', message: 'Необходимо выбрать приемную кампанию', level: 'red'});
      if(this.checkLastName) this.errors.push({element: 'lastName', message: this.checkLastName, level: 'yellow'});
      if(this.checkFirstName) this.errors.push({element: 'firstName', message: this.checkFirstName, level: 'yellow'});
      if(this.checkMiddleName) this.errors.push({element: 'middleName', message: this.checkMiddleName, level: 'yellow'});
      if(this.BirthDate == '') this.errors.push({element: 'birthDate', message: 'Необходимо указать дату рождения', level: 'red'});
      if(this.gender_id == '') this.errors.push({element: 'gender_id', message: 'Необходимо указать пол', level: 'red'});
      if(this.identityDocuments.find(function(element) {
        if(element.documentType == ''){
          entrants.errors.push({element: 'identityDocumentType', message: 'Необходимо выбрать тип документа, удостоверяющего личность', level: 'red'});
        };
      }));
      if(this.checkIdentityDocumentNumber) this.errors.push({element: 'identityDocumentNumber', message: this.checkIdentityDocumentNumber, level: 'red'});
      if(this.identityDocuments.find(function(element) {
        if(element.documentDate == ''){
          entrants.errors.push({element: 'identityDocumentDate', message: 'Необходимо указать дату выдачи документа, удостоверяющего личность', level: 'red'});
        };
      }));
//       if(this.educationDocument.documentType == '') this.errors.push({element: 'education_document_type_id', message: 'Необходимо выбрать тип документа об образовании', level: 'red'});
      if(this.educationDocument.documentNumber == '') this.errors.push({element: 'education_document_number', message: 'Необходимо указать номер документа об образовании', level: 'red'});
      if(this.marks.find(function(element) {
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
      this.identityDocuments.push({documentType: '', documentSerie: '', documentNumber: '', documentDate: '', documentIssuer: '', altEntrantLastName: '', altEntrantFirstName: '', altEntrantMiddleName: ''});
    },
    deleteIdentityDocument: function() {
      if(this.identityDocuments.length > 1) this.identityDocuments.splice(-1, 1);
    },
    addBenefitDocument: function() {
      this.benefitDocuments.push({documentType: '', documentSerie: '', documentNumber: '', documentDate: '', documentIssuer: ''});
    },
    deleteBenefitDocument: function() {
      if(this.benefitDocuments.length > 1) this.benefitDocuments.splice(-1, 1);
    },
    addOlympicDocument: function() {
      this.olympicDocuments.push({documentType: '', documentSerie: '', documentNumber: '', documentDate: '', documentIssuer: ''});
    },
    deleteOlympicDocument: function() {
      if(this.olympicDocuments.length > 1) this.olympicDocuments.splice(-1, 1);
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
  },
  mounted: function() {
    axios
      .get('http://' + this.api.host + '/api/campaigns')
      .then(response => (this.api.campaigns = response.data.campaigns));
    axios
      .get('http://' + this.api.host + '/api/dictionaries/10')
      .then(response => (this.api.specialities_dictionary = response.data.dictionary.items));
    axios
      .get('http://' + this.api.host + '/api/dictionaries/21')
      .then(response => (this.api.countries = response.data.dictionary.items));
    axios
      .get('http://' + this.api.host + '/api/dictionaries/22')
      .then(response => (this.api.identity_document_types = response.data.dictionary.items));
  }
})
