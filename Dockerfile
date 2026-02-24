FROM ruby:3.3-slim

# Configure bundler path so gems are cached in a shared volume
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends build-essential nodejs git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Install Ruby dependencies first (better Docker layer caching)
COPY Gemfile ./
RUN bundle install

# Then copy the rest of the site
COPY . .

EXPOSE 4000

CMD ["sh", "-c", "bundle install && bundle exec jekyll serve --host 0.0.0.0 --port 4000 --watch"]

