import React, { useEffect } from 'react';
// Import các ảnh avatar
import Avatar1 from '../assets/avatar/a1.jpg';
import Avatar2 from '../assets/avatar/a2.jpg';
import Avatar3 from '../assets/avatar/a3.jpg';
import Avatar4 from '../assets/avatar/a4.jpg';
import Avatar5 from '../assets/avatar/a5.jpg';

const About = () => {
    useEffect(() => {
        window.scrollTo(0, 0);
    }, []);

    return (
        <main className="about-page">
           <section className="hero-section h-96 flex items-center justify-center text-center text-white" style={{ background: "linear-gradient(to bottom, rgba(30, 58, 138, 0.8), rgba(30, 58, 138, 0.8)), url('/path-to-your-background-image.jpg')", backgroundSize: 'cover', backgroundPosition: 'center' }}>
                <div className="bg-black bg-opacity-70 p-10 rounded-lg shadow-lg">
                    <h1 className="text-5xl font-bold">Về Chúng Tôi</h1>
                    <p className="mt-4 text-xl">Đối tác thời trang và phong cách đáng tin cậy của bạn.</p>
                </div>
            </section>

            {/* Tổng quan về công ty */}
            <section className="company-overview py-16 px-8 text-center bg-white">
                <h2 className="text-4xl font-bold mb-4">Câu Chuyện Của Chúng Tôi</h2>
                <p className="text-lg text-gray-600 max-w-3xl mx-auto">
                    Kể từ khi thành lập vào năm 2020, chúng tôi đã và đang nỗ lực không ngừng để mang đến những giải pháp sáng tạo và dịch vụ xuất sắc cho khách hàng trên toàn quốc. Chúng tôi tin tưởng vào chất lượng, sự chính trực và cam kết.
                </p>
            </section>

            {/* Phần giá trị cốt lõi */}
            <section className="values-section bg-gray-100 py-16 px-8 text-center">
                <h2 className="text-4xl font-bold mb-8">Giá Trị Cốt Lõi</h2>
                <div className="grid md:grid-cols-3 gap-8">
                    <div className="value-item p-6 bg-white rounded shadow-md">
                        <h3 className="text-2xl font-semibold">Đổi Mới</h3>
                        <p className="text-gray-600 mt-4">Chúng tôi luôn nỗ lực để đi đầu trong công nghệ, không ngừng cải tiến và phát triển.</p>
                    </div>
                    <div className="value-item p-6 bg-white rounded shadow-md">
                        <h3 className="text-2xl font-semibold">Khách Hàng Là Trọng Tâm</h3>
                        <p className="text-gray-600 mt-4">Khách hàng là ưu tiên hàng đầu. Chúng tôi lắng nghe và đáp ứng nhu cầu của họ.</p>
                    </div>
                    <div className="value-item p-6 bg-white rounded shadow-md">
                        <h3 className="text-2xl font-semibold">Chính Trực</h3>
                        <p className="text-gray-600 mt-4">Chúng tôi điều hành doanh nghiệp với sự trung thực và minh bạch.</p>
                    </div>
                </div>
            </section>

            {/* Phần thành viên đội ngũ */}
            <section className="team-section py-16 px-8 text-center">
                <h2 className="text-4xl font-bold mb-8">Đội Ngũ Của Chúng Tôi</h2>
                <div className="container mx-auto">
                    {/* Hàng đầu tiên - 3 thành viên */}
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-2 mb-8">
                        <div className="team-member">
                            <img 
                                src={"data:image/jpeg;base64,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"} 
                                alt="N.Phát"
                                className="rounded-full w-32 h-32 mx-auto mb-4 object-cover border-4 border-primary hover:scale-110 transition-transform duration-300" 
                            />
                            <h3 className="text-xl font-semibold">Tùng Lâm</h3>
                            <p className="text-gray-600">Trưởng Nhóm  Lập Trình Viên</p>
                        </div>
                        <div className="team-member">
                            <img 
                                src={"data:image/png;base64,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"} 
                                alt="H.Phát"
                                className="rounded-full w-32 h-32 mx-auto mb-4 object-cover border-4 border-primary hover:scale-110 transition-transform duration-300" 
                            />
                            <h3 className="text-xl font-semibold">Xuân Quang</h3>
                            <p className="text-gray-600">Lập Trình Viên</p>
                        </div>
                        <div className="team-member">
                            <img 
                                src={"data:image/png;base64,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"} 
                                alt="H.Phát"
                                className="rounded-full w-32 h-32 mx-auto mb-4 object-cover border-4 border-primary hover:scale-110 transition-transform duration-300" 
                             />
                            <h3 className="text-xl font-semibold">Kim Sơn</h3>
                            <p className="text-gray-600">Lập Trình Viên</p>
                        </div>
                        
                      
                    </div>

                  
                </div>
            </section>

            {/* Kêu gọi hành động */}
            <section className="cta-section py-16 px-8 bg-primary text-white text-center">
                <h2 className="text-3xl font-bold mb-4">Sẵn sàng kết nối với chúng tôi?</h2>
                <p className="text-lg mb-8">Hãy cùng chúng tôi đổi mới ngành công nghiệp.</p>
                <a href="/contactus" className="px-8 py-3 bg-white text-primary rounded-full hover:bg-gray-200">
                    Liên Hệ Ngay
                </a>
            </section>
        </main>
    );
};

export default About;
