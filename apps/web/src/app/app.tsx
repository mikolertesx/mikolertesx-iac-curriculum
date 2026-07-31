import Header from './sections/Header';

export function App() {
  return (
    <div className="page">
      <Header />
      <main>
        <section className="section">
          <h2>Summary</h2>
          <p>
            Frontend developer with experience shipping React applications in
            large, multi-team environments. I build UI from product
            specifications, contribute to shared component libraries, and help
            resolve production bugs under pressure.
          </p>
          <p>
            AWS Certified Solutions Architect Associate, with a focus on
            reliable, maintainable frontend systems and cost-aware cloud usage.
          </p>
        </section>

        <section className="section">
          <h2>Experience</h2>

          <article className="entry">
            <div className="entry-header">
              <h3>Frontend Developer</h3>
              <span className="meta">
                EnRoute (client: IAS) · Monterrey · 2021 - Present
              </span>
            </div>
            <ul>
              <li>
                Shipped and maintained customer-facing React applications for
                IAS from product specifications using React, TypeScript, and
                Webpack.
              </li>
              <li>
                Reduced S3 storage and request costs by configuring lifecycle
                policies and cleaning up unused assets.
              </li>
              <li>
                Built and contributed to a shared React component library used
                across multiple teams and products.
              </li>
              <li>
                Built interactive data visualizations and graphs with Highcharts
                for customer-facing dashboards and reporting views.
              </li>
              <li>
                Triaged and fixed production frontend bugs quickly to restore
                customer-facing functionality.
              </li>
              <li>
                Collaborated with product and engineering teams through code
                review, feature deployment, and specs-to-UI delivery.
              </li>
            </ul>
          </article>

          <article className="entry">
            <div className="entry-header">
              <h3>Full-Stack Developer</h3>
              <span className="meta">
                Jehová Jireh · Reynosa · 2022 - 2023 · Side project
              </span>
            </div>
            <ul>
              <li>
                Designed and built custom bookkeeping software for the
                organization, end to end.
              </li>
              <li>
                Implemented RBAC and permissions, transactional flows, and
                precise decimal handling with PostgreSQL.
              </li>
              <li>
                Owned full-stack delivery: frontend, backend, CI/CD, and
                self-hosting on a VPS.
              </li>
            </ul>
          </article>

          <article className="entry">
            <div className="entry-header">
              <h3>Technology Analyst</h3>
              <span className="meta">Deloitte · 2020 - 2021</span>
            </div>
            <ul>
              <li>
                Delivered software solutions for enterprise clients in a
                consulting environment.
              </li>
              <li>
                Built dashboard-specific UI components for client-facing views.
              </li>
            </ul>
          </article>
        </section>

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
