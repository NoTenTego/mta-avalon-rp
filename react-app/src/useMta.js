const useMta = (dispatchFunction) => {
  const w = window;
  w.MtaPrefixSomeName = () => dispatchFunction();
};

export default useMta;