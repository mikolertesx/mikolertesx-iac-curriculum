import Header from './components/Header';

import CertificationSection from './sections/CertificationSection';
import EducationSection from './sections/EducationSection';
import ExperienceSection from './sections/ExperienceSection';
import SkillsSection from './sections/SkillsSection';
import SummarySection from './sections/SummarySection';

export function App() {
  return (
    <div className="page">
      <Header />
      <main>
        <SummarySection />
        <ExperienceSection />
        <EducationSection />
        <CertificationSection />
        <SkillsSection />
      </main>
    </div>
  );
}

export default App;
