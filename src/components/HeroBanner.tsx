import React, { useState, useEffect } from 'react';
import { League } from '../types';

interface HeroBannerProps {
  selectedLeague: number | 'all';
  leagues: League[];
}

const defaultBanners = [
  {
    src: 'https://i.ibb.co/yFYpkNXN/2-img-1915875354-1747434047-b0f62c051926174d7d497230bd0941e51747434047-1920-1920.webp',
    alt: 'Banner promocional de camisetas de time'
  },
  {
    src: 'https://i.ibb.co/4wPmXqnh/2-slide-1747433565035-7669203113-93be0884a503f4ebddd1a85d97f98e101747433568-640-0.webp',
    alt: 'Banner de nova coleção de camisetas'
  }
];

const bundesligaBanner = {
  src: 'https://i.ibb.co/YF4YCf7F/Design-sem-nome-1.png',
  alt: 'Banner da Bundesliga'
};

const laLigaBanner = {
  src: 'https://i.ibb.co/jkPyjw0J/fotos-da-la-liga.jpg',
  alt: 'Banner da La Liga'
};

const brasileiraoBanner = {
  src: 'https://i.ibb.co/60tMmT80/Design-sem-nome-3.png',
  alt: 'Banner do Brasileirão A'
};

const ligaPortugalBanner = {
  src: 'https://i.ibb.co/Lh63fj9G/Design-sem-nome-4.png',
  alt: 'Banner da Liga Portugal'
};

const ligue1Banner = {
  src: 'https://i.ibb.co/mC92tDvn/unnamed-NFMCX9-L2.png',
  alt: 'Banner da Ligue 1'
};

const premierLeagueBanner = {
  src: 'https://i.ibb.co/B5tHtJdF/premier-league-season-preview-aug-2025.webp',
  alt: 'Banner da Premier League'
};

const serieAItalianaBanner = {
  src: 'https://i.ibb.co/Q3MtrcYp/download.jpg',
  alt: 'Banner da Serie A Italiana'
};

const HeroBanner: React.FC<HeroBannerProps> = ({ selectedLeague, leagues }) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [currentBanners, setCurrentBanners] = useState(defaultBanners);

  useEffect(() => {
    const league = leagues.find(l => l.id === selectedLeague);
    if (league) {
      const leagueNameLower = league.name.toLowerCase();
      if (leagueNameLower.includes('bundesliga')) {
        setCurrentBanners([bundesligaBanner]);
      } else if (leagueNameLower.includes('la liga')) {
        setCurrentBanners([laLigaBanner]);
      } else if (leagueNameLower.includes('brasileirão')) {
        setCurrentBanners([brasileiraoBanner]);
      } else if (leagueNameLower.includes('liga portugal')) {
        setCurrentBanners([ligaPortugalBanner]);
      } else if (leagueNameLower.includes('ligue 1')) {
        setCurrentBanners([ligue1Banner]);
      } else if (leagueNameLower.includes('premier league')) {
        setCurrentBanners([premierLeagueBanner]);
      } else if (leagueNameLower.includes('serie a italiana')) {
        setCurrentBanners([serieAItalianaBanner]);
      } else {
        setCurrentBanners(defaultBanners);
      }
    } else {
      setCurrentBanners(defaultBanners);
    }
    setCurrentIndex(0);
  }, [selectedLeague, leagues]);

  useEffect(() => {
    if (currentBanners.length > 1) {
      const timer = setInterval(() => {
        setCurrentIndex((prevIndex) => (prevIndex + 1) % currentBanners.length);
      }, 3000);
      return () => clearInterval(timer);
    }
  }, [currentBanners]);

  return (
    <div className="w-full container mx-auto px-4 pt-4">
      <div className="relative w-full aspect-[2/1] md:aspect-[3/1] lg:aspect-[4/1] overflow-hidden rounded-xl shadow-lg">
        {currentBanners.map((banner, index) => (
          <img
            key={index}
            src={banner.src}
            alt={banner.alt}
            className={`absolute top-0 left-0 w-full h-full object-cover transition-opacity duration-1000 ease-in-out ${
              index === currentIndex ? 'opacity-100' : 'opacity-0'
            }`}
          />
        ))}
         <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2">
          {currentBanners.map((_, index) => (
            <div
              key={index}
              className={`w-2 h-2 rounded-full transition-all duration-300 ${
                index === currentIndex ? 'bg-white scale-125' : 'bg-white/50'
              }`}
            />
          ))}
        </div>
      </div>
    </div>
  );
};

export default HeroBanner;
