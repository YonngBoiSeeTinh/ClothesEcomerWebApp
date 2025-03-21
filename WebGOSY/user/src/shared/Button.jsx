const Button = ({ text, bgColor, textColor, fontSize, onClick = () => {} }) => {
    return (
        <button
            className={`${bgColor} ${textColor} ${fontSize} cursor-pointer hover:scale-105 duration-300 py-2 px-8 rounded-full relative z-10`}
            onClick={onClick}
        >
            {text}
        </button>
    );
};

export default Button;
