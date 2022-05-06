window.search_modal = {
  manufacturers_input_val: null,
  models_input_val: null,
  types_input_val: null
};

jQuery(function() {

  // Mega menu

  $(".main-nav").mouseover(function() {
    $(".blackout").fadeIn("fast")
  }).mouseleave(function() {
    $(".blackout").fadeOut("fast")
  })



  // Mobile menu

  var $hamburger = $('.hamburger');
  $hamburger.on("click", function(e) {
    $hamburger.toggleClass('is-active');
    $('.main-nav').slideToggle('fast');
  });



  // Mobile mega menu

  $(".main-nav .nav-item").on('click', function(e) {
    if ($(this).find('.sub-menu').length > 0) $(this).toggleClass('active');
  });



  // Tooltips

  $('header .user-signup, header .shopping-cart').tooltip({
    placement: 'bottom'
  });

  $('.owl-carousel .brand').tooltip({
    html: true
  });

  $('footer .social-icon').tooltip();



  // Carousels

  $('.hero-carousel').owlCarousel({
    items: 1,
    autoplay: true,
    autoplayHoverPause: true,
    autoplaySpeed: 1000,
    loop: true
  });

  $('.brands-carousel').owlCarousel({
    autoplay: true,
    autoplayTimeout: 3000,
    autoplayHoverPause: true,
    autoplaySpeed: 600,
    loop: true,
    responsive:{
      0: {
        items: 3,
        dots: false
      },
      400: {
        items: 5,
        dots: false
      },
      768:{
        items: 7,
        dots: true
      },
      1024:{
        items: 10,
        dots: true
      }
    }
  });

  $('.products-carousel').owlCarousel({
    dots: false,
    loop: true,
    margin: 20,
    nav: true,
    responsive:{
      575: {
        items: 1
      },
      768:{
        items: 3
      },
      1024:{
        items: 4
      }
    }
  });



  // Hide tabs on aside

  if( window.screen.width < 767 ) {
    $('aside .search-tabs .search-car-colors').removeClass('active');
    $('aside .search-tabs-content .tab-pane').removeClass('active show');
  }



  // Same height on products list

  function resizeProductThumbs() {
    var maxNameHeight = 0;
    var maxDescHeight = 0;
    $('.products-list').each(function() {
      $('.product-thumb', this).each(function() {
        var currNameHeight = $('.name', this).height();
        if( currNameHeight > maxNameHeight ) maxNameHeight = currNameHeight;
        var currDescHeight = $('.excerpt', this).height();
        if( currDescHeight > maxDescHeight ) maxDescHeight = currDescHeight;
      });
      $('.product-thumb .name', this).css('min-height', maxNameHeight);
      $('.product-thumb .excerpt', this).css('min-height', maxDescHeight);
    });
  }
  resizeProductThumbs();



  $(window).on('resize', function() {
    resizeProductThumbs();
  });



  // Show all colors

  $('.show-all-colors').on('click', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.hidden-colors').fadeIn();
  });



  // Show all reviews

  $('.show-all-reviews').on('click', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.hidden-reviews').fadeIn();
  });



  // Aside search

  window.addEventListener("pageshow", () => {

    aside_form[0].reset();
    jQuery('#form_autoricambi button, #form_autoricambi select#form_autoricambi_type, #form_autoricambi select#form_autoricambi_models').attr('disabled', true);
    jQuery('#form_autoricambi select#form_autoricambi_type, #form_autoricambi select#form_autoricambi_models, #form_autoricambi select#form_autoricambi_manufacturers').find("option.items, optgroup.items").remove();

    const manufacturers_input = jQuery('#form_autoricambi select#form_autoricambi_manufacturers');
    const manufacturers = new Request('api/manufacturers');
    fetch(manufacturers)
        .then(response => response.json())
        .then(data => {
          console.log(manufacturers_input)
          manufacturers_input.find("option.items").remove();
          for (let i = 0; i < data.length; i++) {
            manufacturers_input.append('<option class="items" value="' + data[i].id + '">' + data[i].name + '</option>');
          }
          manufacturers_input.attr('disabled', false);
        })
        .catch(console.error);

  });

  const aside_form = jQuery('#form_autoricambi');
  if (aside_form .length > 0) {

    window.addEventListener("pageshow", () => {

      aside_form[0].reset();
      jQuery('#form_autoricambi button, #form_autoricambi select#form_autoricambi_type, #form_autoricambi select#form_autoricambi_models').attr('disabled', true);
      jQuery.when(jQuery('#form_autoricambi select#form_autoricambi_type, #form_autoricambi select#form_autoricambi_models, #form_autoricambi select#form_autoricambi_manufacturers').find("option.items, optgroup.items").remove()).then(function () {

        const manufacturers_input = jQuery('#form_autoricambi select#form_autoricambi_manufacturers');
        const manufacturers = new Request('api/manufacturers');
        fetch(manufacturers)
            .then(response => response.json())
            .then(data => {
              console.log("data")
              manufacturers_input.find("option.items").remove();
              for (let i = 0; i < data.length; i++) {
                manufacturers_input.append('<option class="items" value="' + data[i].id + '">' + data[i].name + '</option>');
              }
              manufacturers_input.attr('disabled', false);
            })
            .catch(console.error);

      });

    });

    const manufacturers_input = jQuery('#form_autoricambi select#form_autoricambi_manufacturers');
    const models_input = jQuery('#form_autoricambi select#form_autoricambi_models');
    const types_input = jQuery('#form_autoricambi select#form_autoricambi_type');
    const submit_button = jQuery('#form_autoricambi button');

    const manufacturers = new Request('api/manufacturers');
    fetch(manufacturers)
        .then(response => response.json())
        .then(data => {
          console.log("data")
          manufacturers_input.find("option.items").remove();
          for (let i = 0; i < data.length; i++) {
            manufacturers_input.append('<option class="items" value="' + data[i].id + '">' + data[i].name + '</option>');
          }
          manufacturers_input.attr('disabled', false);
        })
        .catch(console.error);

    manufacturers_input.on('change', function () {
      const value = jQuery(this).val();
      if (value > 0) {
        const models = new Request('api/models/' + value);
        fetch(models)
          .then(response => response.json())
          .then(data => {
            console.log('models', data)
            models_input.find("option.items, optgroup.items").remove();
            types_input.find("option.items, optgroup.items").remove();
            types_input.attr('disabled', true);
            submit_button.attr('disabled', true);
            if (data && data.length > 0) {
              let series = null;
              for (let i = 0; i < data.length; i++) {
                if (series !== data[i].series) models_input.append('<optgroup class="items" label="' + data[i].series + '" />')
                const from = data[i].from ? moment(data[i].from, "YYYY-MM") : null;
                const to = data[i].to ? moment(data[i].to, "YYYY-MM") : null;
                let interval = '';
                if (to && from) interval = from.format('MM/YYYY') + '-' + to.format('MM/YYYY');
                if (!to && from) interval = from.format('MM/YYYY');
                if (interval !== '') interval = '(' + interval + ')';
                models_input.append('<option class="items" value="' + data[i].id + '">&#160;' + data[i].name + ' ' + interval + '</option>');
                series = data[i].series;
              }
              models_input.attr('disabled', false);
            }
          })
          .catch(console.error);
      } else {
        models_input.find("option.items, optgroup.items").remove();
        models_input.attr('disabled', true);
        types_input.find("option.items, optgroup.items").remove();
        types_input.attr('disabled', true);
        submit_button.attr('disabled', true);
      }
    });

    models_input.on('change', function () {
      const value = jQuery(this).val();
      if (value > 0) {
        const types = new Request('api/types/' + value);
        fetch(types)
          .then(response => response.json())
          .then(data => {
            console.log('types', data)
            types_input.attr('disabled', true);
            submit_button.attr('disabled', true);
            types_input.find("option.items, optgroup.items").remove();
            if (data && data.length > 0) {
              let fuel_type = null;
              for (let i = 0; i < data.length; i++) {
                if (fuel_type !== data[i].properties.fuel_type) types_input.append('<optgroup class="items" label="' + data[i].properties.fuel_type + '" />')
                const from = data[i].from ? moment(data[i].from, "YYYY-MM") : null;
                const to = data[i].to ? moment(data[i].to, "YYYY-MM") : null;
                let interval = '';
                if (to && from) interval = from.format('MM/YYYY') + '-' + to.format('MM/YYYY');
                if (!to && from) interval = from.format('MM/YYYY');
                if (interval !== '') interval = '(' + interval + ')';
                types_input.append('<option class="items" value="' + data[i].id + '">&#160;' + data[i].name + ' ' + data[i].properties.fuel_type + ' (HP ' + data[i].properties.hp + ', KW ' + data[i].properties.kw + ') ' + interval + '</option>');
                fuel_type = data[i].properties.fuel_type;
              }
              types_input.attr('disabled', false);
              submit_button.attr('disabled', false);
            }
          })
          .catch(console.error);
      } else {
        types_input.find("option.items, optgroup.items").remove();
        types_input.attr('disabled', true);
        submit_button.attr('disabled', true);
      }
    });

    types_input.on('change', function () {
      const value = jQuery(this).val();
      if (value > 0) submit_button.attr('disabled', false);
      else submit_button.attr('disabled', true);
    });

  }

  jQuery(document).on("submit", "form#form_autoricambi", function (e) {
    e.preventDefault();
    e.stopImmediatePropagation();
    window.search_modal.manufacturers_input_val = jQuery('#form_autoricambi select#form_autoricambi_manufacturers').val();
    window.search_modal.models_input_val = jQuery('#form_autoricambi select#form_autoricambi_models').val();
    window.search_modal.types_input_val = jQuery('#form_autoricambi select#form_autoricambi_type').val();
    jQuery('#search-popup').modal('show');
  });
  jQuery('#search-popup').on('show.bs.modal', function (e) {
    jQuery("#search-popup-contents").load('search-popup.jsp?id_marca=' + window.search_modal.manufacturers_input_val + '&id_modello=' + window.search_modal.models_input_val + '&id_tipo=' + window.search_modal.types_input_val, function(response, status, xhr) {
      if (status === "error") {
        let msg = "Sorry but there was an error: ";
        alert(msg + xhr.status + " " + xhr.statusText);
      }
      window.search_modal = {
        manufacturers_input_val: null,
        models_input_val: null,
        types_input_val: null
      };
    });
  })


});
