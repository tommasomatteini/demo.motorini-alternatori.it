$(function() {

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

  const aside_form = jQuery('#form_autoricambi');
  if (aside_form .length > 0) {

    window.addEventListener("pageshow", () => {
      aside_form[0].reset();
    });

    const manufacturers_input = jQuery('#form_autoricambi select#form_autoricambi_manufacturers');
    const models_input = jQuery('#form_autoricambi select#form_autoricambi_models');
    const types_input = jQuery('#form_autoricambi select#form_autoricambi_type');
    const submit_button = jQuery('#form_autoricambi button');

    const manufacturers = new Request('api/manufacturers');
    fetch(manufacturers)
      .then(response => response.json())
      .then(data => {
        manufacturers_input.find("option.items").remove();
        for(let i = 0; i < data.length; i++) {
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
            models_input.find("option.items").remove();
            types_input.find("option.items").remove();
            types_input.attr('disabled', true);
            submit_button.attr('disabled', true);
            for (let i = 0; i < data.length; i++) {
              const from = data[i].from ? moment(data[i].from, "YYYY-MM") : null;
              const to = data[i].to ? moment(data[i].to, "YYYY-MM") : null;
              const interval = to ? ( from.format('MM/YYYY') + '-' + to.format('MM/YYYY') ) : ( from.format('MM/YYYY') );
              models_input.append('<option class="items" value="' + data[i].id + '">' + data[i].name + ' (' + interval + ')</option>');
            }
            models_input.attr('disabled', false);
          })
          .catch(console.error);
      } else {
        models_input.find("option.items").remove();
        models_input.attr('disabled', true);
        types_input.find("option.items").remove();
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
            types_input.find("option.items").remove();
            for (let i = 0; i < data.length; i++) {
              const from = data[i].from ? moment(data[i].from, "YYYY-MM") : null;
              const to = data[i].to ? moment(data[i].to, "YYYY-MM") : null;
              const interval = to ? ( from.format('MM/YYYY') + '-' + to.format('MM/YYYY') ) : ( from.format('MM/YYYY') );
              types_input.append('<option class="items" value="' + data[i].id + '">' + data[i].name + ' ' + data[i].properties.fuel_type + ' (HP ' + data[i].properties.hp + ', KW ' + data[i].properties.kw + ') (' + interval + ')</option>');
            }
            types_input.attr('disabled', false);
          })
          .catch(console.error);
      } else {
        types_input.find("option.items").remove();
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



});
