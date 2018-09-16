var entrants = new Vue({
  el: '#entrant',
  data: {
    errors: [],
	  campaigns: [],
    personal: {
      lastNamePlaceholder: 'Как в паспорте',
      firstNamePlaceholder: 'Как в паспорте',
      middleNamePlaceholder: 'Как в паспорте, если есть',
      lastName: '',
      firstName: '',
      middleName: '',
      sex: '',
      birthDate: ''
    },
    identityDocuments: [
      {
        documentType: '',
        documentSerie: '',
        documentNumber: '',
        documentDate: '',
        documentIssuer: ''
      }
    ],
    educationDocument: {
	    documentType: '',
	    documentSerie: '',
	    documentNumber: '',
	    documentDate: '',
	    documentIssuer: '',
	    isPrime: false
    },
	  contactInformation: {
		  address: '',
		  zipCode: '',
		  email: '',
		  phone: ''
	  },
	  competitionGroups: [],
	  targetOrganization: '',
	  benefitDocuments: [
		  {
			  documentType: '',
			  documentSerie: '',
			  documentNumber: '',
			  documentDate: '',
			  documentIssuer: ''
		  }
	  ],
	  olympionicDocuments: [
		  {
			  documentType: '',
			  documentSerie: '',
			  documentNumber: '',
			  documentYear: 2018
		  }
	  ],
	  competitions: [],
	  individualAchievements: [],
	  needHostel: false
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
    }
  },
  methods: {
    checkForm: function() {
      this.errors = [];
      if(this.checkLastName) this.errors.push({element: 'lastName', message: this.checkLastName, level: 'yellow'});
      if(this.checkFirstName) this.errors.push({element: 'firstName', message: this.checkFirstName, level: 'yellow'});
      if(this.checkMiddleName) this.errors.push({element: 'middleName', message: this.checkMiddleName, level: 'yellow'});
      if(this.checkBirthDate) this.errors.push({element: 'BirthDate', message: this.checkBirthDate, level: 'red'});
    },
    addIdentityDocument: function() {
      this.identityDocuments.push({documentType: '', documentSerie: '', documentNumber: '', documentDate: '', documentIssuer: ''});
    }
  }
})
