import ExperienceSection from './sections/ExperienceSection';
import Header from './sections/Header';
import SummarySection from './sections/SummarySection';

export function App() {
  return (
    <div className="page">
      <Header />
      <main>
        <SummarySection/>
        <ExperienceSection />
        <section className="section">
          <h2>Education</h2>

          <article className="entry">
            <div className="entry-header">
              <h3>B.S. Mechatronics Engineering</h3>
              <span className="meta">TecMilenio · 2017 - 2021</span>
            </div>
            <p>
              Mechatronics Engineering with a strong software focus:
              programming, systems, and automation.
            </p>
          </article>
        </section>

        <section className="section">
          <h2>Certifications</h2>

          <article className="entry">
            <div className="entry-header">
              <h3>AWS Certified Solutions Architect - Associate</h3>
              <span className="meta">Amazon Web Services</span>
            </div>
          </article>
        </section>

        <section className="section">
          <h2>Skills</h2>
          <ul className="skills">
            <li>JavaScript</li>
            <li>TypeScript</li>
            <li>React</li>
            <li>Next.js</li>
            <li>NestJS</li>
            <li>HTML</li>
            <li>CSS</li>
            <li>Tailwind CSS</li>
            <li>Sass</li>
            <li>CSS Modules</li>
            <li>Styled Components</li>
            <li>Webpack</li>
            <li>Component libraries</li>
            <li>Highcharts</li>
            <li>Data visualization</li>
            <li>Git</li>
            <li>CI/CD</li>
            <li>PostgreSQL</li>
            <li>AWS</li>
            <li>Code review</li>
            <li>Storybook</li>
          </ul>
        </section>
      </main>
    </div>
  );
}

export default App;
