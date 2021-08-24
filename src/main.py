import streamlit as st
from streamlit.hashing import _CodeHasher
from streamlit.report_thread import get_report_ctx
from streamlit.server.server import Server
from sh import pandoc, ErrorReturnCode_2

def main():
    state = _get_state()
    pages = {
        "Getting Started": page_getting_started,
        "-- Markdown": page_markdown,
        "-- Images": page_images,
        "-- Bibliography": page_bibliography,
        "-- Settings": page_settings,
        "-- Download": page_download,
        "About": page_about,
    }

    st.sidebar.title(":pencil: Typademic")
    st.sidebar.text("An academic publishing pipeline")
    page = st.sidebar.radio("", tuple(pages.keys()))

    # Display the selected page with the session state
    pages[page](state)

    # Mandatory to avoid rollbacks with widgets, must be called at the end of your app
    state.sync()


def page_getting_started(state):

    # Docs
    # TODO read README.md into state and separate list via split("\n# ")
    with open("README.md", "r") as f:
        text = f.read()
        text = text.split("# Contributing")
        st.markdown(text[0])


def page_markdown(state):
    # https://pypi.org/project/python-frontmatter/

    # Docs
    with open("docs/Markdown.md", "r") as f:
        st.markdown(f.read())


def page_images(state):
    st.title(":camera: Images")
    # https://docs.streamlit.io/en/stable/api.html#streamlit.file_uploader
    # https://docs.streamlit.io/en/stable/api.html?highlight=cache#streamlit.cache
    # uploaded_file = st.file_uploader("Choose a file")
    # if uploaded_file is not None:
    #     # To read file as string:
    #     string_data = stringio.read()
    #     st.write(string_data)

    # uploaded_files = st.file_uploader("Choose a CSV file", accept_multiple_files=True)
    # for uploaded_file in uploaded_files:
    #     bytes_data = uploaded_file.read()
    #     st.write("filename:", uploaded_file.name)
    #     st.write(bytes_data)


def page_bibliography(state):
    st.title(":book: Bibliography")
    with open("docs/Bibliography.md", "r") as f:
        st.markdown(f.read())


def page_about(state):
    with open("README.md", "r") as f:
        text = f.read()
        text = text.rsplit("# Contributing")
        st.title("About")
        st.markdown(text[1])


def page_download(state):
    st.title(":chart_with_upwards_trend: Dashboard page")
    display_state_values(state)
    # https://amoffat.github.io/sh/
    try:
        pandoc("/doesnt/exist")
    except ErrorReturnCode_2:
        print("directory doesn't exist")


def page_settings(state):
    st.title(":wrench: Settings")

    options = ["Hello", "World", "Goodbye"]
    state.input = st.text_input("Set input value.", state.input or "")
    state.slider = st.slider("Set slider value.", 1, 10, state.slider)
    state.radio = st.radio(
        "Set radio value.", options, options.index(state.radio) if state.radio else 0
    )
    state.checkbox = st.checkbox("Set checkbox value.", state.checkbox)
    state.selectbox = st.selectbox(
        "Select value.",
        options,
        options.index(state.selectbox) if state.selectbox else 0,
    )
    state.multiselect = st.multiselect("Select value(s).", options, state.multiselect)

    # Dynamic state assignments
    for i in range(3):
        key = f"State value {i}"
        state[key] = st.slider(f"Set value {i}", 1, 10, state[key])

    # Docs
    with open("docs/Pandoc.md", "r") as f:
        st.markdown(f.read())


def display_state_values(state):
    st.write("Input state:", state.input)
    st.write("Slider state:", state.slider)
    st.write("Radio state:", state.radio)
    st.write("Checkbox state:", state.checkbox)
    st.write("Selectbox state:", state.selectbox)
    st.write("Multiselect state:", state.multiselect)

    for i in range(3):
        st.write(f"Value {i}:", state[f"State value {i}"])

    if st.button("Clear state"):
        state.clear()


class _SessionState:
    def __init__(self, session, hash_funcs):
        """Initialize SessionState instance."""
        self.__dict__["_state"] = {
            "data": {},
            "hash": None,
            "hasher": _CodeHasher(hash_funcs),
            "is_rerun": False,
            "session": session,
        }

    def __call__(self, **kwargs):
        """Initialize state data once."""
        for item, value in kwargs.items():
            if item not in self._state["data"]:
                self._state["data"][item] = value

    def __getitem__(self, item):
        """Return a saved state value, None if item is undefined."""
        return self._state["data"].get(item, None)

    def __getattr__(self, item):
        """Return a saved state value, None if item is undefined."""
        return self._state["data"].get(item, None)

    def __setitem__(self, item, value):
        """Set state value."""
        self._state["data"][item] = value

    def __setattr__(self, item, value):
        """Set state value."""
        self._state["data"][item] = value

    def clear(self):
        """Clear session state and request a rerun."""
        self._state["data"].clear()
        self._state["session"].request_rerun()

    def sync(self):
        """Rerun the app with all state values up to date from the beginning to fix rollbacks."""

        # Ensure to rerun only once to avoid infinite loops
        # caused by a constantly changing state value at each run.
        #
        # Example: state.value += 1
        if self._state["is_rerun"]:
            self._state["is_rerun"] = False

        elif self._state["hash"] is not None:
            if self._state["hash"] != self._state["hasher"].to_bytes(
                self._state["data"], None
            ):
                self._state["is_rerun"] = True
                self._state["session"].request_rerun()

        self._state["hash"] = self._state["hasher"].to_bytes(self._state["data"], None)


def _get_session():
    session_id = get_report_ctx().session_id
    session_info = Server.get_current()._get_session_info(session_id)

    if session_info is None:
        raise RuntimeError("Couldn't get your Streamlit Session object.")

    return session_info.session


def _get_state(hash_funcs=None):
    session = _get_session()

    if not hasattr(session, "_custom_session_state"):
        session._custom_session_state = _SessionState(session, hash_funcs)

    return session._custom_session_state


if __name__ == "__main__":
    main()
