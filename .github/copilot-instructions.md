# Copilot Instructions

## Project Guidelines
- Khi chỉnh HeroSection, cần giữ nguyên layout/CSS structure hiện có và chỉ thay đổi nội dung bên trong các class cũ; các phần như All Series phải bám đúng markup để không làm lệch tông giao diện.

## Notification Handling
- Replace `alert()` with toast notifications in `Register.cshtml` when validation fails.
- Use the existing `showToast()` function in `_LayoutAuth.cshtml` to display toast messages with success/error icons that auto-dismiss after 3 seconds.

## JavaScript Styling Preferences
- Use the `.css()` method for styling in JavaScript rather than toggling classes, especially for simple color changes in UI elements like favorite hearts.