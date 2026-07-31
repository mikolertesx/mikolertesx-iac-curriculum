interface SectionPropsI extends React.PropsWithChildren { 
    title: string;
}

const Section = ({ children, title }: SectionPropsI) => {
    return <section className="mb-8">
        <h2 className="text-lg font-semibold uppercase mb-2 pb-2">{title}</h2>
        {children}
    </section>
};

export default Section;
