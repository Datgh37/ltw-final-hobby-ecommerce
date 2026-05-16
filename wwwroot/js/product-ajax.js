/**
 * Product AJAX Filtering & Pagination
 * Separated logic for better maintainability
 */

$(document).ready(function () {
    // Selectors
    const container = '#product-list-container';
    const paginationSelector = '.product__pagination a';
    const filterFormSelector = '.price-filter-form, .filter__sort form';

    // 1. Handle Pagination Clicks
    $(document).on('click', paginationSelector, function (e) {
        e.preventDefault();
        const url = $(this).attr('href');
        if (!url || url === '#' || url === '') return;

        loadProductList(url);
        
        // Update Browser URL
        window.history.pushState({ path: url }, '', url);
    });

    // 2. Handle Filter/Sort Form Submissions
    $(document).on('submit', filterFormSelector, function (e) {
        e.preventDefault();
        const $form = $(this);
        const url = $form.attr('action');
        const formData = $form.serialize();
        const fullUrl = url + (url.includes('?') ? '&' : '?') + formData;

        loadProductList(fullUrl);

        // Update Browser URL
        window.history.pushState({ path: fullUrl }, '', fullUrl);
    });

    // 3. Main AJAX Loader
    function loadProductList(url) {
        // Convert to Filter partial URL
        const ajaxUrl = url.replace('/Products/Index', '/Products/Filter')
                           .replace('/Products?', '/Products/Filter?')
                           .replace('/Products#', '/Products/Filter#');

        // Show loading state
        $(container).css('opacity', '0.5');
        
        $.ajax({
            url: ajaxUrl,
            type: 'GET',
            success: function (result) {
                $(container).html(result);
                $(container).css('opacity', '1');
                
                // Re-initialize plugins
                initializePlugins();
            },
            error: function () {
                $(container).css('opacity', '1');
                alert('Có lỗi xảy ra khi tải danh sách sản phẩm.');
            }
        });
    }

    // 4. Helper to re-initialize Ogani plugins
    function initializePlugins() {
        $('.set-bg').each(function () {
            var bg = $(this).data('setbg');
            $(this).css('background-image', 'url(' + bg + ')');
        });

        if ($.fn.niceSelect) {
            $('select').niceSelect();
        }
    }

    // 5. Handle Browser Back/Forward
    window.onpopstate = function (e) {
        if (e.state && e.state.path) {
            loadProductList(e.state.path);
        }
    };
});
