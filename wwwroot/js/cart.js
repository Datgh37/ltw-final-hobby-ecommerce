/**
 * Cart Module Logic
 * Handles: Add to Cart, Update Quantity, Delete Item, and Notifications
 */

// 1. Global Toast Notification
function showToast(message, type = 'info') {
    const container = document.getElementById('toast-container');
    if (!container) return;
    const toast = document.createElement('div');
    toast.className = `toast-msg toast-${type}`;
    toast.innerHTML = `<i class="fa ${type === 'success' ? 'fa-check-circle' : (type === 'error' ? 'fa-exclamation-circle' : 'fa-info-circle')} mr-2"></i> ${message}`;
    
    container.appendChild(toast);
    setTimeout(() => { 
        toast.style.opacity = '0';
        setTimeout(() => toast.remove(), 300); 
    }, 3000);
}

// 2. Custom Confirm Modal
function showConfirm(message, onConfirm, onCancel) {
    if ($('#custom-confirm-modal').length === 0) {
        $('body').append(`
            <div class="custom-modal-overlay" id="custom-confirm-modal">
                <div class="custom-modal">
                    <div class="custom-modal-icon">
                        <i class="fa fa-exclamation-triangle"></i>
                    </div>
                    <h3 class="custom-modal-title">Xác nhận</h3>
                    <p class="custom-modal-message"></p>
                    <div class="modal-btns">
                        <button class="modal-btn btn-cancel">
                            <i class="fa fa-times mr-1"></i> Hủy bỏ
                        </button>
                        <button class="modal-btn btn-confirm">
                            <i class="fa fa-check mr-1"></i> Đồng ý
                        </button>
                    </div>
                </div>
            </div>
        `);
    }

    const modal = $('#custom-confirm-modal');
    modal.find('.custom-modal-message').text(message);
    modal.css('display', 'flex');
    setTimeout(() => modal.find('.custom-modal').addClass('active'), 30);

    modal.find('.btn-confirm').off('click').on('click', function() {
        closeConfirmModal();
        if (onConfirm) onConfirm();
    });

    modal.find('.btn-cancel').off('click').on('click', function() {
        closeConfirmModal();
        if (onCancel) onCancel();
    });
}

function closeConfirmModal() {
    const modal = $('#custom-confirm-modal');
    modal.find('.custom-modal').removeClass('active');
    setTimeout(() => modal.css('display', 'none'), 250);
}

// 3. Add to Cart Logic
function addToCart(productId, quantity = 1) {
    $.ajax({
        url: "/Cart/AddToCart",
        type: "POST",
        data: { productId, quantity },
        success: function(response) {
            if (response.success) {
                reloadCartPreview();
                showToast(response.message, 'success');
            } else {
                showToast(response.message, 'error');
            }
        },
        error: function() {
            showToast("Lỗi kết nối máy chủ", "error");
        }
    });
}

// 4. Update Cart Quantity (Main Cart Page)
function updateCartQuantity(cartItemId, quantity, row) {
    $.ajax({
        url: "/Cart/UpdateQuantity",
        type: "POST",
        data: { cartItemId, quantity },
        success: function(response) {
            if (response.success) {
                row.find(".subtotal").text(response.subtotal + " ₫");
                updateGlobalTotals(response.grandTotal, response.totalItems);
                reloadCartPreview();
            }
        }
    });
}

// 5. Delete Cart Item
function deleteCartItem(cartItemId, row, silent = false) {
    const performDelete = function() {
        $.ajax({
            url: "/Cart/DeleteCartItem",
            type: "POST",
            data: { cartItemId },
            success: function(response) {
                if (response.success) {
                    if (row) {
                        row.fadeOut(300, function() { 
                            $(this).remove(); 
                            if ($(".cart-row").length === 0) location.reload(); 
                        });
                    }
                    updateGlobalTotals(response.grandTotal, response.totalItems);
                    reloadCartPreview();
                    if (!silent) showToast("Đã xóa sản phẩm khỏi giỏ hàng", "success");
                }
            }
        });
    };

    if (silent) {
        performDelete();
    } else {
        showConfirm("Bạn có chắc chắn muốn xóa sản phẩm này?", performDelete);
    }
}

// 6. Reload Cart Preview HTML (Fix recursion)
function reloadCartPreview() {
    $.get("/Cart/GetCartPreview", function(html) {
        $(".cart-vc-content").html(html);
        const newCount = $(".cart-dropdown").data("total-count");
        if (newCount !== undefined) $(".cart-count").text(newCount);
    });
}

// 7. Update Totals in Cart Index
function updateGlobalTotals(grandTotal, totalItems) {
    $("#grand-total").text(grandTotal + " ₫");
    $(".shoping__checkout ul li:first-child span").text(grandTotal + " ₫"); 
    $(".cart-count").text(totalItems);
}

// 8. Event Listeners
$(document).ready(function() {
    // Add to Cart
    $(document).on("click", ".add-to-cart-btn, .add-to-cart", function(e) {
        e.preventDefault();
        const productId = $(this).data("product-id");
        const quantity = parseInt($("#productQuantity").val()) || 1;
        addToCart(productId, quantity);
    });

    // Main Cart Page Quantity
    $(document).on("click", ".qtybtn", function() {
        const container = $(this).parent();
        const maxStock = parseInt(container.data("max-stock")) || 999;
        const row = $(this).closest(".cart-row");
        if (!row.length) return;
        const cartItemId = row.data("cart-item-id");
        const input = row.find(".qty-input");

        setTimeout(function() {
            let quantity = parseInt(input.val());
            
            if (quantity > maxStock) {
                showToast(`Chỉ còn ${maxStock} sản phẩm trong kho`, "error");
                input.val(maxStock);
                quantity = maxStock;
            }

            if (isNaN(quantity) || quantity <= 0) {
                deleteCartItem(cartItemId, row);
            } else {
                updateCartQuantity(cartItemId, quantity, row);
            }
        }, 150);
    });

    // Main Cart Page Delete
    $(document).on("click", ".delete-cart-item", function(e) {
        e.preventDefault();
        deleteCartItem($(this).data("cart-item-id"), $(this).closest(".cart-row"));
    });

    // --- Preview Dropdown Quantity Controls ---
    $(document).on("click", ".cart-preview-dec", function(e) {
        e.preventDefault();
        const item = $(this).closest(".cart-dropdown__item");
        const cartItemId = item.data("cart-item-id");
        const countSpan = item.find(".cart-preview-count");
        let qty = parseInt(countSpan.text()) - 1;

        if (qty <= 0) {
            deleteCartItem(cartItemId, null, true); // Auto delete silent
        } else {
            countSpan.text(qty);
            updateCartQuantity(cartItemId, qty, $()); 
        }
    });

    $(document).on("click", ".cart-preview-inc", function(e) {
        e.preventDefault();
        const item = $(this).closest(".cart-dropdown__item");
        const maxStock = parseInt(item.data("max-stock")) || 999;
        const cartItemId = item.data("cart-item-id");
        const countSpan = item.find(".cart-preview-count");
        let qty = parseInt(countSpan.text()) + 1;

        if (qty > maxStock) {
            showToast(`Vượt quá số lượng tồn kho (${maxStock})`, "error");
            return;
        }

        countSpan.text(qty);
        updateCartQuantity(cartItemId, qty, $());
    });
});
