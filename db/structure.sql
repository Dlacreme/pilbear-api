--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: gender_enum; Type: TYPE; Schema: public; Owner: dlacreme
--

CREATE TYPE public.gender_enum AS ENUM (
    'male',
    'female'
);


ALTER TYPE public.gender_enum OWNER TO dlacreme;

--
-- Name: user_provider_enum; Type: TYPE; Schema: public; Owner: dlacreme
--

CREATE TYPE public.user_provider_enum AS ENUM (
    'google',
    'facebook'
);


ALTER TYPE public.user_provider_enum OWNER TO dlacreme;

--
-- Name: user_role_enum; Type: TYPE; Schema: public; Owner: dlacreme
--

CREATE TYPE public.user_role_enum AS ENUM (
    'admin',
    'user'
);


ALTER TYPE public.user_role_enum OWNER TO dlacreme;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: dlacreme
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    label character varying(255) NOT NULL,
    country_id character varying(3) NOT NULL
);


ALTER TABLE public.cities OWNER TO dlacreme;

--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: dlacreme
--

CREATE SEQUENCE public.cities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cities_id_seq OWNER TO dlacreme;

--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dlacreme
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: dlacreme
--

CREATE TABLE public.countries (
    id character varying(3) NOT NULL,
    language_id character varying(3) NOT NULL,
    label character varying(255) NOT NULL
);


ALTER TABLE public.countries OWNER TO dlacreme;

--
-- Name: languages; Type: TABLE; Schema: public; Owner: dlacreme
--

CREATE TABLE public.languages (
    id character varying(3) NOT NULL,
    label character varying(55) NOT NULL,
    label_en character varying(55) NOT NULL
);


ALTER TABLE public.languages OWNER TO dlacreme;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: dlacreme
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    label character varying(254) NOT NULL,
    description character varying(254) NOT NULL,
    lat real NOT NULL,
    lng real NOT NULL,
    city_id integer NOT NULL,
    created_by_id integer NOT NULL,
    google_id character varying(254) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.locations OWNER TO dlacreme;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: dlacreme
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.locations_id_seq OWNER TO dlacreme;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dlacreme
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: migration_versions; Type: TABLE; Schema: public; Owner: dlacreme
--

CREATE TABLE public.migration_versions (
    id integer NOT NULL,
    version character varying(17) NOT NULL
);


ALTER TABLE public.migration_versions OWNER TO dlacreme;

--
-- Name: migration_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: dlacreme
--

CREATE SEQUENCE public.migration_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migration_versions_id_seq OWNER TO dlacreme;

--
-- Name: migration_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dlacreme
--

ALTER SEQUENCE public.migration_versions_id_seq OWNED BY public.migration_versions.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: dlacreme
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    nickname character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    gender public.gender_enum,
    birthdate timestamp without time zone,
    picture_url character varying(500)
);


ALTER TABLE public.profiles OWNER TO dlacreme;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: dlacreme
--

CREATE SEQUENCE public.profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profiles_id_seq OWNER TO dlacreme;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dlacreme
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: dlacreme
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255),
    user_provider public.user_provider_enum,
    provider_id character varying(255),
    user_role public.user_role_enum,
    profile_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO dlacreme;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: dlacreme
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO dlacreme;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dlacreme
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: migration_versions id; Type: DEFAULT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.migration_versions ALTER COLUMN id SET DEFAULT nextval('public.migration_versions_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: migration_versions migration_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.migration_versions
    ADD CONSTRAINT migration_versions_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: user_email_index; Type: INDEX; Schema: public; Owner: dlacreme
--

CREATE UNIQUE INDEX user_email_index ON public.users USING btree (email);


--
-- Name: users fk_cr_a8794354f0; Type: FK CONSTRAINT; Schema: public; Owner: dlacreme
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_cr_a8794354f0 FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

