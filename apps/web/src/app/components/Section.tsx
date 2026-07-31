interface SectionPropsI extends React.PropsWithChildren { }

const Section = ({ children }: SectionPropsI) => {
    return <section className="mb-8">
        {children}
    </section>
};

export default Section;
