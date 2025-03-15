import Button from "../../shared/Button";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import PathNames from "../../PathNames";
import { API_URL } from "../../config";
import { useEffect, useState } from "react";

const Featured = () => {
    const navigate = useNavigate();
    const handleCategoryBrowse = (brand) => {
        navigate(`${PathNames.SHOP}`, { state: { brand: brand } })
    }
    const [catogiries, setCategories] = useState([]);
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
            <div className="grid grid-cols-1 gap-4 sm:gap-8 sm:grid-cols-2 lg:grid-cols-3">
                {catogiries.map((category)=>(
                    <div
                     onClick={() => handleCategoryBrowse(category.id)}
                     className="py-10 pl-5 bg-gradient-to-tr from-gray-300 to-white 
                     text-white rounded-3xl relative h-[100px] sm:h-[220px] flex items-end"
                    > 
                        <div className="mb-4 sm:mt-5" >
                            <p className="my-3 text-4xl xl:text-5xl">
                                {category.name}
                            </p>
                        </div>
                        <img
                            src={`data:image/jpeg;base64,${category?.image}`}
                            alt=""
                            className="2xl:w-[100px] h-32 xl:w-48 lg:w-32 md:w-52 sm:w-44  absolute bottom-0 right-2 sm:-right-4 md:-right-3 lg:-right-2 xl:-right-4 2xl:-right-2 object-contain top-1/2 -translate-y-1/2 "
                        />
                    </div> 
                   
                ))}
               </div>
            </div>
        </section>
    );
};

export default Featured;
