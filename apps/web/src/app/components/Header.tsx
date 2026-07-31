
import portrait from '../../assets/portrait.jpeg';
import { VisitorCount } from '../visitor-count';

const Header = () => {
    return       <header className="header">
        <img
          className="portrait"
          src={portrait}
          alt="Portrait of Miguel Angel Guerrero Salinas"
          width={120}
          height={120}
        />
        <div className="header-text">
          <h1 className="name">Miguel Angel Guerrero Salinas</h1>
          <p className="title">
            Frontend Developer · AWS Certified Solutions Architect Associate
          </p>
          <ul className="contact">
            <li>
              <a href="mailto:miguel-guerrero-business@proton.me">
                miguel-guerrero-business@proton.me
              </a>
            </li>
            <li>
              <a href="https://www.linkedin.com/in/miguel-angel-guerrero-salinas-15aa76185/">
                LinkedIn
              </a>
            </li>
            <li>
              <a href="https://github.com/mikolertesx">GitHub</a>
            </li>
            <li>Mexico</li>
          </ul>
          <div className="visitor-row">
            <VisitorCount />
          </div>
        </div>
      </header>
};

export default Header;
