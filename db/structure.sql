--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 11.5 (Debian 11.5-1+deb10u1)

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
-- Name: delivery_slot_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.delivery_slot_state AS ENUM (
    'open',
    'closing',
    'closed',
    'full'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: delivery_costs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_costs (
    id integer NOT NULL,
    cost_pence integer NOT NULL,
    minimum_spend_pence integer NOT NULL,
    label text,
    delivery_slot_id integer NOT NULL
);


--
-- Name: delivery_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_slots (
    id integer NOT NULL,
    state public.delivery_slot_state
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    filename text NOT NULL
);


--
-- Name: delivery_costs delivery_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_costs
    ADD CONSTRAINT delivery_costs_pkey PRIMARY KEY (id);


--
-- Name: delivery_slots delivery_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_slots
    ADD CONSTRAINT delivery_slots_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: delivery_costs delivery_costs_delivery_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_costs
    ADD CONSTRAINT delivery_costs_delivery_slot_id_fkey FOREIGN KEY (delivery_slot_id) REFERENCES public.delivery_slots(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

