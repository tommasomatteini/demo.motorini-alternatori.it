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

    const manufacturers_input = jQuery('select#form_autoricambi_manufacturers');
    const manufacturers = new Request('api/manufacturers');
    fetch(manufacturers)
      .then(response => response.json())
      .then(data => {
        for(let i = 0; i < data.length; i++) {
          manufacturers_input.append('<option value="' + data[i].id + '">' + data[i].name + '</option>');
        }
        manufacturers_input.attr('disabled', false);
      })
      .catch(console.error);
    manufacturers_input.on('change', function () {
      const value = jQuery(this).val();
      const models_input = jQuery('select#form_autoricambi_models');
      const models = new Request('api/models/' + value);
      fetch(models)
          .then(response => response.json())
          .then(data => {
            for(let i = 0; i < data.length; i++) {
              models_input.append('<option value="' + data[i].id + '">' + data[i].name + '</option>');
            }
            models_input.attr('disabled', false);
          })
          .catch(console.error);
    })


  }



});
