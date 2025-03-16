import Button from "../../shared/Button";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import PathNames from "../../PathNames";
import { API_URL } from "../../config";
import { useEffect, useState } from "react";

const Featured = () => {
    const navigate = useNavigate();
    const handleCategoryBrowse = (category) => {
        navigate(`${PathNames.SHOP}`, { state: { category: category } })
    }
    const [categories, setCategories] = useState([]);
    useEffect(() => {
        const fetchProducts = async () => {
            try {
                const response = await axios.get(`${API_URL}/api/Categories`);
                setCategories(response.data);
            } catch (error) {
                console.error("Lỗi khi tải sản phẩm:", error);
            }
        };
        fetchProducts();
    }, []);
    return (
        <section className="py-8">
            <div className="container">
            <div className="flex gap-4 overflow-x-auto py-4">
            {categories.map((category) => (
                <div
                    key={category.id}
                    onClick={() => handleCategoryBrowse(category.id)}
                    className="flex-none w-[48%]  lg:w-[30%] py-6 px-4  text-black 
                    rounded-3xl relative h-[100px] sm:h-[200px] flex flex-col justify-between cursor-pointer category_item"
                >
                    {/* Nội dung bên trên */}
                    <div className="flex justify-between items-center">
                        <p className="text-lg  sm:text-[40px] lg:text-[40px] font-bold sm:font-semibold">
                            {category.name}
                        </p>
                        <img
                            src={`data:image/jpeg;base64,${category?.image}`}
                            alt=""
                            className="w-16 sm:w-20 lg:w-24 object-contain"
                        />
                    </div>

                    {/* Nội dung bên dưới */}
                    <div className="text-sm sm:text-base  hidden  xl:hiden lg:block">
                        <p>Trải nghiệm các sản phẩm tuyệt vời</p>
                    </div>
                </div>
            ))}
      
            </div>
            </div>
        </section>
    );
};

export default Featured;
