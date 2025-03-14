import { Carousel } from "antd";
import axios from "axios";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import {  API_URL   } from "../../config";
import PathNames from "../../PathNames.js";
import Button from "../../shared/Button.jsx";
import { BorderOutlined } from "@ant-design/icons";

// const HeroPlaceholderData = [
//     {
//         id: 1,
//         image: Img1,
//         title: "Wireless",
//         title2: "Heaphones",
//         description: "Beats Solo",
//     },
//     {
//         id: 2,
//         image: Img2,
//         title: "Wireless",
//         title2: "Virtual",
//         description: "Beats Duo",
//     },
// ];

const Hero = () => {
    const [products, setProducts] = useState([]);
    const navigate = useNavigate();

    useEffect(() => {
        const fetchProducts = async () => {
            try {
                const response = await axios.get(`${API_URL}/api/Products`);
                const productsData = response.data;
                setProducts(productsData);
            } catch (error) {
                console.error(error);
            }
        };
        fetchProducts();
    }, []);

    const getProductsById = (ids) => {
        return products.filter((product) => ids.includes(product.id));
    };
    const heroProducts = getProductsById([4, 3]);
    console.log("Hero products:", heroProducts);

    const handleHeroClick = (productId) => {
        navigate(`${PathNames.PRODUCT_DETAILS}/${productId}`);
    };

    // useEffect(() => {
    //     console.log("Logged hero products id" + handleHeroClick.productId);
    // }, [handleHeroClick.productId]);

    return (
        <div className="container">
            <div className="overflow-hidden rounded-3xl min-h-[550px] sm:min-h-[650px]  flex justify-center items-center mt-10 mb-11 shadow-[0px_8px_20px_rgba(0,0,0,0.5)]">
                <div className="container pb-8 sm:pb-0">
                    <Carousel
                        dots={false}
                        arrows={false}
                        infinite={true}
                        speed={800}
                        draggable={true}
                        autoplay={true}
                        autoplaySpeed={4000}
                        easing="ease-in-out"
                    >
                        {heroProducts.map((product) => (
                            <div key={product.id}>
                                <div className="grid grid-cols-1 sm:grid-cols-2">
                                    {/* text content section */}
                                    <div className="flex flex-col justify-center gap-4 sm:pl-3 pt-12 sm:pt-0 text-center sm:text-left order-2 sm:order-1 relative z-10">
                                        
                                        <h1
                                            className=" sm:text-4xl lg:text-5xl font-bold text-indigo-200  sm:text-[70px] md:text-[70px] xl:text-[100px] mb-10"
                                            data-aos-once={false}
                                            style={{textShadow:"-2px 12px 8px rgb(12, 0, 65)" }}
                                        >
                                             {product.promo} % Off
                                        </h1>
                                        <h1
                                            className="text-2xl uppercase  text-gray-200  sm:text-[20px] md:text-[30px] xl:text-[50px] font-bold leading-none mb-5"
                                           
                                            style={{textShadow:"2px 4px 1px rgba(0, 0, 0, 0.5)" }}
                                        >
                                            {product.name}
                                        </h1>
                                        <h1
                                            className="text-2xl   text-gray-200  sm:text-[18px] md:text-[25px] xl:text-[40px] font-bold leading-none "
                                          
                                            style={{textShadow:"0px 5px 1px rgba(0, 0, 0, 0.5)" }}
                                            data-aos-duration="500"
                                            data-aos-once={false}
                                        >
                                            Sep 10 - Sep 17
                                        </h1>
                                        <div
                                            className="rounded-lg border-2 border-indigo-300 cursor-pointer w-[350px] h-[70px]
                                             p-2 hover:bg-indigo-100 transition-all duration-300 
                                             flex items-center justify-center my-4"
                                            onClick={() => handleHeroClick(product.id)}
                                            >
                                            <p className="text-indigo-300 font-bold text-[40px]">Mua Ngay</p>
                                        </div>
                                            
                                    </div>

                                    {/* Img section */}
                                    <div className="order-1 sm:order-2">
                                        <div data-aos="fade-left"
                                            data-aos-duration="500"
                                            data-aos-once={false}>
                                            <img
                                                src={`data:image/jpeg;base64,${product.image}`}
                                                alt=""
                                                className="w-[300px] sm:w-[450px] h-[320px] sm:h-[470px] sm:scale-105 lg:scale-110 object-contain mx-auto  relative z-40"
                                            />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        ))}
                    </Carousel>
                </div>
            </div>
        </div>
    );
};

export default Hero;
