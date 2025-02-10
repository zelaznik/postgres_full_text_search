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
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: escape_html(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.escape_html(input_text text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    escaped_text TEXT;
BEGIN
    -- Replace special HTML characters with their corresponding HTML entities
    escaped_text := REPLACE(input_text, '&', '&amp;');
    escaped_text := REPLACE(escaped_text, '<', '&lt;');
    escaped_text := REPLACE(escaped_text, '>', '&gt;');
    escaped_text := REPLACE(escaped_text, '"', '&quot;');
    escaped_text := REPLACE(escaped_text, '''', '&#39;');

    RETURN escaped_text;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles (
    id integer NOT NULL,
    data json NOT NULL,
    http_status integer,
    body text,
    error text,
    title text GENERATED ALWAYS AS ((data ->> 'title'::text)) STORED,
    url text GENERATED ALWAYS AS ((data ->> 'url'::text)) STORED
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.articles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: search_terms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.search_terms (
    id integer NOT NULL,
    term text NOT NULL,
    frequency integer NOT NULL
);


--
-- Name: search_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.search_terms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.search_terms_id_seq OWNED BY public.search_terms.id;


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: search_terms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_terms ALTER COLUMN id SET DEFAULT nextval('public.search_terms_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: search_terms search_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_terms
    ADD CONSTRAINT search_terms_pkey PRIMARY KEY (id);


--
-- Name: idx_fts_articles_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fts_articles_title ON public.articles USING gin (to_tsvector('english'::regconfig, title));


--
-- Name: idx_search_terms; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_search_terms ON public.search_terms USING gist (term public.gist_trgm_ops);


--
-- Name: idx_trigram_articles_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trigram_articles_title ON public.articles USING gist (title public.gist_trgm_ops);


--
-- Name: idx_uniq_search_terms; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_uniq_search_terms ON public.search_terms USING btree (lower(term));


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250209030205'),
('20250209024658'),
('20250208214532'),
('20250208180757'),
('20250208180302'),
('20250208175804'),
('20250202183039'),
('20250202170827');

