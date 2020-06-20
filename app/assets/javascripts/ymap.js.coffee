address = $('#map').data('address')
name = $('#map').data('name')
latitude = $('#map').data('latitude')
longitude = $('#map').data('longitude')
init = -> (myMap = new ymaps.Map("map"
					      center: [latitude, longitude]
					      zoom: 15
					      behaviors: ['default', 'scrollZoom'])
myMap.geoObjects.add(new ymaps.Placemark([latitude, longitude], {
						    iconContent: name
						    balloonContent: address
						    }
						    {
						    preset: 'twirl#redStretchyIcon'
						    balloonMaxWidth: '250'
						    })))
ymaps.ready init