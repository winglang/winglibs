import React, {useState, useEffect} from 'react';

const GithubIcon = () => {
  return (  
    <svg width="24px" height="24px" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path fillRule="evenodd" clipRule="evenodd" d="M16 0C7.16 0 0 7.3411 0 16.4047C0 23.6638 4.58 29.795 10.94 31.9687C11.74 32.1122 12.04 31.6201 12.04 31.1894C12.04 30.7998 12.02 29.508 12.02 28.1341C8 28.8928 6.96 27.1293 6.64 26.2065C6.46 25.7349 5.68 24.279 5 23.8893C4.44 23.5818 3.64 22.823 4.98 22.8025C6.24 22.782 7.14 23.9919 7.44 24.484C8.88 26.9652 11.18 26.268 12.1 25.8374C12.24 24.7711 12.66 24.0534 13.12 23.6433C9.56 23.2332 5.84 21.8183 5.84 15.5435C5.84 13.7594 6.46 12.283 7.48 11.1347C7.32 10.7246 6.76 9.04309 7.64 6.78745C7.64 6.78745 8.98 6.35682 12.04 8.46893C13.32 8.09982 14.68 7.91527 16.04 7.91527C17.4 7.91527 18.76 8.09982 20.04 8.46893C23.1 6.33632 24.44 6.78745 24.44 6.78745C25.32 9.04309 24.76 10.7246 24.6 11.1347C25.62 12.283 26.24 13.7389 26.24 15.5435C26.24 21.8388 22.5 23.2332 18.94 23.6433C19.52 24.1559 20.02 25.1402 20.02 26.6781C20.02 28.8723 20 30.6358 20 31.1894C20 31.6201 20.3 32.1327 21.1 31.9687C27.42 29.795 32 23.6433 32 16.4047C32 7.3411 24.84 0 16 0Z" fill="currentColor"></path>
    </svg>
  );
}

export const GitHubButton = () => {
  const [stars, setStars] = useState('0');
  const [watchersCount, setWatchersCount] = useState(0);

  useEffect(() => {
    const getStarsCount = async () => {
      const res = await fetch('https://api.github.com/repos/winglang/wing');
      const data = await res.json();
      setWatchersCount(data.watchers_count);
    };
    getStarsCount();
  }, []);

  useEffect(() => {

      const round = (number: number): string => {
          if(!number) {
              return "-1";
          }
          return (Math.round(number / 100) * 100).toString();
      }

      const stars = watchersCount ? round(Number(watchersCount)) : "-1";
      const starsK = stars.length > 3 ?
        `${stars.slice(0, -3)}.${stars.slice(-3, -2)}k` : stars;
      setStars(starsK);
  }, [watchersCount]);

  return (
    <div className="navbar__item nav-git-button">
      <a href="https://github.com/winglang/wing" target="_blank" className="nav-git">
        <GithubIcon />
        <div>Star us</div>
        {stars !== '-1' && (
        <>
         <div className="line-sep"></div>
         <div>⭐️ {stars}</div>
        </>)}
      </a>
    </div>
  );
}

export default GitHubButton;
