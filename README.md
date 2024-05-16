<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/your_username/repo_name">
    <img src="images/coffee-icon1.png" alt="Logo" width="80" height="80">
  </a>
  <h3 align="center">Tên Dự Án Của Bạn</h3>
  <p align="center">
    Một mô tả ngắn về dự án của bạn!
    <br />
    <a href="https://github.com/your_username/repo_name"><strong>Khám phá tài liệu »</strong></a>
    <br />
    <br />
    <a href="https://github.com/your_username/repo_name">Xem Demo</a>
    ·
    <a href="https://github.com/your_username/repo_name/issues">Báo cáo lỗi</a>
    ·
    <a href="https://github.com/your_username/repo_name/issues">Yêu cầu tính năng</a>
  </p>
</div>
<!-- TABLE OF CONTENTS -->
<details>
  <summary>Mục lục</summary>
  <ol>
    <li>
      <a href="#about-the-project">Tổng quan về dự án</a>
      <ul>
        <li><a href="#problem-statement">Đặt vấn đề</a></li>
        <li><a href="#objectives">Mục tiêu</a></li>
        <li><a href="#significance">Ý nghĩa đề tài</a></li>
      </ul>
    </li>
    <li>
      <a href="#design">Thiết kế</a>
      <ul>
        <li><a href="#use-case-diagram">Sơ đồ use-case</a></li>
        <li><a href="#database-design">Thiết kế cơ sở dữ liệu</a></li>
      </ul>
    </li>
    <li>
      <a href="#interface">Giao diện</a>
    </li>
  </ol>
</details>
<!-- ABOUT THE PROJECT -->
<h1>Tổng quan về dự án</h1>
<p>Ứng dụng quản lý quán cà phê Coffee Shop cung cấp các chức năng phù hợp cho cả người dùng (khách hàng) và quản trị viên (admin) như sau:</p>
<pre>
<b>Chức năng của Người Dùng (Khách hàng):</b>

Xem Thực Đơn:
Người dùng có thể xem thực đơn của quán cà phê với các món ăn, thức uống và giá cả tương ứng.

Đặt Hàng:
Người dùng có thể đặt hàng trực tuyến thông qua ứng dụng bằng cách chọn món ăn, thức uống và thêm vào giỏ hàng

Thanh Toán:
Người dùng có thể thanh toán cho đơn hàng của mình từ giỏ hàng

Quản Lý Tài Khoản:
Người dùng có thể đăng nhập vào tài khoản của mình để theo dõi lịch sử đơn hàng, quản lý thông tin cá nhân.

<b>Chức năng của Quản Trị Viên (Admin):</b>

Quản Lý Thực Đơn:
Quản trị viên có thể thêm, sửa đổi hoặc xóa các món ăn, thức uống trên thực đơn của quán cà phê.

Quản Lý Đơn Hàng:
Quản trị viên có thể xem và quản lý tất cả các đơn hàng được đặt trực tuyến thông qua ứng dụng.

Quản Lý Khách Hàng:
Quản trị viên có thể quản lý thông tin thanh toán của khách hàng.

Thống Kê và Báo Cáo:
Quản trị viên có thể xem các báo cáo và thống kê về doanh số bán hàng, sản phẩm phổ biến, hoạt động của khách hàng, và các chỉ số quan trọng khác 
để đưa ra các quyết định kinh doanh hiệu quả.
</pre>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- DESIGN -->

<h1>Sơ đồ use-case</h1>

<img src="images/User_CoffeeShop.jpg" alt="Logo">
<h3 align="center">User Use-case</h3>

<img src="images/Admin_CoffeeShop.jpg" alt="Logo">
<h3 align="center">Admin Use-case</h3>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<h1>Sơ đồ cơ sở dữ liệu</h1>

<div align="center"><img src="images/firestore1.drawio.png" alt="Logo"></div>
<h3 align="center">Sơ đồ database</h3>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- INTERFACE -->
<h1>Giao diện</h1>

<h1>Giao diện cơ bản</h1>

<div align="center"><img src="images/welcome_page.png" alt="Logo" height="800"></div>
<h4 align="center">Trang welcome</h4>

<div align="center"><img src="images/sign_in.png" alt="Logo" height="800"></div>
<h4 align="center">Trang sign in</h4>

<pre>
User có thể sign in bằng email hoặc sign in thông qua tài khoản Google
Admin chỉ có thể sign in bằng email
</pre>

<div align="center"><img src="images/register.png" alt="Logo" height="800"></div>
<h4 align="center">Trang Register</h4>

<h2>Giao diện khi đang nhập bằng tài khoản user</h2>

<div align="center"><img src="images/user_main_page.png" alt="Logo" height="800"></div>
<h4 align="center">Trang chủ</h4>

<div align="center"><img src="images/search.png" alt="Logo" height="800"></div>
<h4 align="center">Thanh search</h4>

<div align="center"><img src="images/user_fav_page.png" alt="Logo" height="800"></div>
<h4 align="center">Trang favourite</h4>

<div align="center"><img src="images/detailed_product.png" alt="Logo" height="800"></div>
<h4 align="center">Trang chi tiết sản phẩm</h4>

<div align="center"><img src="images/cart.png" alt="Logo" height="800"></div>
<h4 align="center">Trang giỏ hàng</h4>

<div align="center"><img src="images/order_confirm.png" alt="Logo" height="800"></div>
<h4 align="center">Xác nhận đặt hàng</h4>

<div align="center"><img src="images/acc_setting.png" alt="Logo" height="800"></div>
<h4 align="center">Trang thông tin tài khoản</h4>

<div align="center"><img src="images/change_pass.png" alt="Logo" height="800"></div>
<h4 align="center">Đổi mật khẩu</h4>

<h2>Giao diện khi đang nhập bằng tài khoản admin</h2>

<div align="center"><img src="images/admin_main.png" alt="Logo" height="800"></div>
<h4 align="center">Trang chủ</h4>

<div align="center"><img src="images/search.png" alt="Logo" height="800"></div>
<h4 align="center">Thanh search</h4>

<div align="center"><img src="images/edit_product.png" alt="Logo" height="800"></div>
<h4 align="center">Bảng chỉnh sửa thông tin món ăn</h4>

<div align="center"><img src="images/add_product.png" alt="Logo" height="800"></div>
<h4 align="center">Bảng thêm món ăn</h4>

<div align="center"><img src="images/admin_bill.png" alt="Logo" height="800"></div>
<h4 align="center">Trang danh sách hóa đơn</h4>

<div align="center"><img src="images/acc_setting.png" alt="Logo" height="800"></div>
<h4 align="center">Trang thông tin tài khoản</h4>

<div align="center"><img src="images/change_pass.png" alt="Logo" height="800"></div>
<h4 align="center">Đổi mật khẩu</h4>
