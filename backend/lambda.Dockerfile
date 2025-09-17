FROM public.ecr.aws/lambda/python:3.13

# Set environment variable for poetry timeout
ENV POETRY_REQUESTS_TIMEOUT=10800

# Copy pyproject.toml and poetry.lock
COPY ./pyproject.toml ./poetry.lock ./

# Install pip, poetry, and dependencies
RUN python -m pip install --upgrade pip && \
    pip install poetry --no-cache-dir && \
    poetry config virtualenvs.create false && \
    # Ensure the poetry.lock is up to date
    poetry lock && \
    poetry install --no-interaction --no-ansi --only main && \
    poetry cache clear --all pypi

# Copy application files
COPY ./app ./app
COPY ./embedding_statemachine ./embedding_statemachine

# Define Lambda handler entry point
CMD ["app.websocket.handler"]
