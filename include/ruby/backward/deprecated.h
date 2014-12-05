#ifndef RUBY_RUBY_BACKWARD_DEPRECATED_H
#define RUBY_RUBY_BACKWARD_DEPRECATED_H 1

/* complex.c */
DEPRECATED(VALUE rb_complex_set_real(VALUE, VALUE));
DEPRECATED(VALUE rb_complex_set_imag(VALUE, VALUE));

/* eval.c */
DEPRECATED(static inline void rb_disable_super(void));
DEPRECATED(static inline void rb_enable_super(void));
static inline void rb_disable_super(void)
{
    /* obsolete - no use */
}
static inline void rb_enable_super(void)
{
    rb_warning("rb_enable_super() is obsolete");
}
#define rb_disable_super(klass, name) rb_disable_super()
#define rb_enable_super(klass, name) rb_enable_super()

DEPRECATED(void rb_clear_cache(void));

/* hash.c */
DEPRECATED(int rb_hash_iter_lev(VALUE));
DEPRECATED(VALUE rb_hash_ifnone(VALUE));

/* string.c */
DEPRECATED(void rb_str_associate(VALUE, VALUE));
DEPRECATED(VALUE rb_str_associated(VALUE));

/* vm.c */
DEPRECATED(void rb_frame_pop(void));

#endif /* RUBY_RUBY_BACKWARD_DEPRECATED_H */
